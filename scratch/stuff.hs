
-- bar x [] = x
-- bar _ (x:xs) = bar x xs
--
-- foo :: [Char] -> Bool
-- foo [] = True
-- foo (x:xs) = (x == bar x xs) && (foo xs)

-- twicer x = (x,x)
-- a = zip (fst t) (snd t) where t = twicer (take 10 [2,4..])
-- b = take 10 $ zip t t where t = [2,4..]
-- c = twicer (take 10 t) where t = [2,4..]
-- d = map twicer (take 10 [2,4..])

-- data PairorTriple = Pair Int Int | Triple Int Int Int
--
-- foo :: Pair -> Int
-- foo (Pair x y) = x + y

type Parser a = String -> [(a, String)]

dotsdash = do many1 (char '.')
              char '-'
customParser = many (dotsdash)
inputString = ("")

parse customParser inputString
