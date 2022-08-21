import Data.Char
import W

import Control.Applicative (Applicative(..))
import Control.Monad (liftM, ap)

-- the only kind of expression supported for now is stringLiterals
-- implement the full expression language of W
expr = term >>= termSeq

termSeq left = ( (symbol "&&" +++ symbol "||") >>= \s ->
                  term >>= \right ->
                  termSeq ((toOp s) left right)) +++
               ( (symbol "=" +++ symbol "!=" +++
                  symbol "<" +++ symbol ">" +++
                  symbol "<=" +++ symbol ">=") >>= \s ->
                  term >>= \right ->
                  termSeq ((toOp s) left right)) +++
               ( (symbol "+" +++ symbol "-") >>= \s ->
                 term >>= \right ->
                 termSeq ((toOp s) left right)
               ) +++ return left

term = factor >>= factorSeq

factorSeq left = ( (symbol "*" +++ symbol "/") >>= \s ->
                   factor >>= \right ->
                   factorSeq ((toOp s) left right)
                 ) +++ return left

factor = ( nat >>= \i ->
           return (Val (VInt i))
         ) +++ parens expr

-- intLiteral = stringLiteral ('\n')

-- stringLiterals can contain \n characters
stringLiteral = char ('"') >>
                many stringChar >>= \s ->
                char ('"') >>
                whitespace >>
                return (Val (VString s))

stringChar = (char '\\' >> char 'n' >> return '\n')
             +++ sat (/= '"')

toOp "+" = Plus
toOp "-" = Minus
toOp "*" = Multiplies
toOp "/" = Divides
toOp "=" = Equals
toOp "!=" = NotEqual
toOp "<" = Less
toOp ">" = Greater
toOp "<=" = LessOrEqual
toOp ">=" = GreaterOrEqual

----------------------
-- Parser utilities --
----------------------

keywords = words "var if else while"
isKeyword s = s `elem` keywords

keyword s =
  identifier >>= \s' ->
  if s' == s then return s else failure

newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp

instance Functor Parser where
    -- fmap :: (a -> b) -> Parser a -> Parser b
      -- liftM :: (Monad m) => (a1 -> r) -> m a1 -> m r
    fmap = liftM

instance Applicative Parser where
    pure  = return
    (<*>) = ap

instance Monad Parser where
    -- return :: a -> Parser a
    return v = P $ \inp -> [(v, inp)]

    -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
    p >>= q = P $ \inp -> case parse p inp of
                            [] -> []
                            [(v, inp')] -> let q' = q v in parse q' inp'

failure :: Parser a
failure = P $ \_ -> []

item :: Parser Char
item = P $ \inp -> case inp of
                     (x:xs) -> [(x, xs)]
                     [] -> []

-- Parse with p or q
(+++) :: Parser a -> Parser a -> Parser a
p +++ q = P $ \inp -> case parse p inp of
                          [] -> parse q inp
                          [(v, inp')] -> [(v, inp')]


-- Simple helper parsers
sat :: (Char -> Bool) -> Parser Char
sat pred = item >>= \c ->
           if pred c then return c else failure

digit, letter, alphanum :: Parser Char
digit = sat isDigit
letter = sat isAlpha
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char x = sat (== x)

string = sequence . map char

many1 :: Parser a -> Parser [a]
many1 p = p >>= \v ->
          many p >>= \vs ->
          return (v:vs)

many :: Parser a -> Parser [a]
many p = many1 p +++ return []

-- Useful building blocks
nat :: Parser Int
nat = many1 digit >>= \s ->
      whitespace >>
      return (read s)

identifier :: Parser String
identifier = letter >>= \s ->
             many alphanum >>= \ss ->
             whitespace >>
             return (s:ss)

whitespace :: Parser ()
whitespace = many (sat isSpace) >> comment

symbol s =
    string s >>= \s' ->
    whitespace >>
    return s'

comment = ( string "//" >>
            many (sat (/= '\n')) >>
            whitespace ) +++ return ()

parens p =
    symbol "(" >>
    p >>= \res ->
    symbol ")" >>
    return res
