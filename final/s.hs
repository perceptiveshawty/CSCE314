{-

Sachin Chanchani
828004948
CSCE 314 - 500
Aggies do not lie, cheat, steal, or tolerate those who do.

-}

import Data.Char

import Control.Applicative (Applicative(..))
import Control.Monad (liftM, ap)

{-

Q1: The e-code

-}

ecode :: [Char] -> [Char]
ecode [x] = []
ecode [x, y] = if x == 'e' then [y] else []
ecode (x:xs) | (x == 'e') = [head xs] ++ ecode (tail xs)
             | otherwise  = ecode xs


{-

Q2: (25 Points: A binary trie)

-}

data BinTrie = Branch Bool BinTrie BinTrie | Leaf Bool -- leaf cons modified
    deriving (Show)

l0 = Branch (True) (Leaf False) (Leaf True)

l10 = Branch (False) (Leaf False) (l0)
l11 = Branch (True) (Leaf False) (Leaf True)
l12 = Branch (True) (Leaf False) (Leaf True)

l20 = Branch (True) (Leaf False) (l10)
l21 = Branch (False) (l11) (l12)

r = Branch (False) (l20) (l21)

-- 2.1

printExpr :: BinTrie -> String
printExpr (Leaf b) = "[LE " ++ (show b) ++ " AF]"
printExpr (Branch b x y) = "(" ++ (printExpr x) ++ " " ++ (show b) ++ " " ++ (printExpr y) ++ ")"

-- 2.2

treeElem :: [Int] -> BinTrie -> Bool
treeElem [x] (Leaf b) = if b == True then True else False
treeElem [x] (Branch b y z) = if (x == 1) then (treeElem [x] z) else (treeElem [x] y)
treeElem (x:xs) (Leaf b) = if b == True then True else False
treeElem (x:xs) (Branch b y z) | (x == 1) = treeElem xs z
                               | otherwise = treeElem xs y


-- 2.3
-- 2.3 Write a function treeCard :: BinTrie -> Int that indicates the cardinality of the set of
-- binary numbers represented by the binary trie. (For the example above, it should
-- return 4.)

treeCard :: BinTrie -> Int
treeCard t = (fromIntegral (treeCardHelper t) `div` 2)

treeCardHelper :: BinTrie -> Int
treeCardHelper (Leaf b) = 1
treeCardHelper (Branch b y z) = ((treeCard y) + (treeCard z))

{-

Q3: Parsing

-}

dot :: Parser Char
dot = char '.'

dash :: Parser Char
dash = char '-'

-- 3.1
morseString = many (cParser +++ bParser +++ dParser +++ aParser +++ eParser)

eParser = dot >> return 'E'
dParser = dash >> dot >> dot >> return 'D'
cParser = dash >> dot >> dash >> dot >> return 'C'
bParser = dash >> dot >> dot >> dot >> return 'B'
aParser = dot >> dash >> return 'A'

-- 3.2
manyOdd :: Parser a -> Parser [a]
manyOdd p = p >>= \v ->
            many pair >>= \vs ->
            return (v:vs)

pair :: Parser a -> Parser [a]
pair p = p >>= \v ->
         p >>= \u ->
         return (item >> v) ++ (item >> u)


-- oddHelper :: Parser a -> (Int, Parser [a])
-- oddHelper p = many1 p >>= \vs ->
--               return ((length vs), vs)

{-

Q4: sets

-}

-- 4.1
bigUnion :: Eq a => [[a]] -> [a]
bigUnion s = unionHelper s []

unionHelper :: Eq a => [[a]] -> [a] -> [a]
unionHelper ([x]:xs) s   | not (elem x s) = bigUnion (xs) ++ ([x]:s)
                         | otherwise      = bigUnion (xs)
unionHelper ((h:x):xs) s | not (elem h s) = bigUnion (x:xs) ++ ([h]:s)
                         | otherwise      = bigUnion (x:xs)


{-

Q5: rjuns

-}

-- 5.1

runSummary s = zip (mkSet s) (map [(ct x s) | x <- (mkSet s)] (mkSet s))

ct _ [] = 0
ct x xs = (length . filter (== x)) xs

mkSet [] = []
mkSet [z] = [z]
mkSet (y:ys) | elem y ys  = mkSet ys
             | otherwise  = (mkSet [y]) ++ (mkSet ys)


-- 5.2

longestRunsOnly s = findLongestRun s currLongest

findLongestRun s currLongest = -- what i would have done if i had time is keep track of the longest string then return it

----------------------
-- Parser utilities --
----------------------

keywords = words "var if else while true false True False"
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
