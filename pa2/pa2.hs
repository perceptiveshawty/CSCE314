{-

CSCE 314-500
Sachin Chanchani (828004948)
Graded Programming Assignment 2

-}

-- Write a function, crt, that takes as input a list of tuples,
-- (ai, ni), each with a remainder ai and a number ni.
-- You can assume all the ni are pairwise coprime.
-- From them, you should produce a new tuple, (a, n),
-- where n is the product of the ni, and a is x mod n,
-- or the smallest number that meets the criteria.

-- a = x % n
-- (x - a) % n = 0

-- (a, n)

-- f([ni]) = n0 * n1 * ... == upper limit on x
-- g(a, n) = [xlist]
-- g([xlist1], [xlist2], ...) = min element in all lists

crt :: [(Integer, Integer)] -> (Integer, Integer)
crt ts = outputPair (xModN (consolidateLists (ts) (xUpperLim ts) []) []) (xUpperLim ts)

-- Helper functions for CRT

xUpperLim :: [(Integer, Integer)] -> Integer
xUpperLim [] = 1
xUpperLim (x:xs) = (snd x) * (xUpperLim xs)

xList :: (Integer, Integer) -> Integer -> [Integer] -> [Integer]
xList (a, n) l [] = xList (a, n) l [a] -- base case: empty list starts with a
xList (a, n) l xs | ((last xs) + n) < l = xList (a, n) l (xs ++ [(last xs) + n]) -- otherwise inc prev elem by n, record
                  | otherwise           = xs

elemIsCommon :: Integer -> [[Integer]] -> Bool
elemIsCommon _ [] = True
elemIsCommon e (x:xs) | elem e x        = elemIsCommon e xs
                      | otherwise       = False

xModN :: [[Integer]] -> [Integer] -> Integer
xModN (x:xs) cs | length x == 1 && elemIsCommon (head x) xs        = minimum (cs ++ [head x])
                | length x == 1 && not (elemIsCommon (head x) xs)  = minimum cs
                | elemIsCommon (head x) xs                          = xModN ((tail x):xs) (cs ++ [head x])
                | otherwise                                         = xModN ((tail x):xs) (cs)

consolidateLists :: [(Integer, Integer)] -> Integer -> [[Integer]] -> [[Integer]]
consolidateLists [] _ ls = ls
consolidateLists (x:xs) lim ls = consolidateLists (xs) lim ((xList (x) (lim) []):ls)

outputPair :: Integer -> Integer -> (Integer, Integer)
outputPair a n = (a, n)

-- Suppose a natural number n has the set of factors {1, f1, f2,…, fk, n}
-- where its factors have been written in increasing order so that
-- the trivial factors, 1 and n, sandwich the rest. Since we have
-- k non-trivial factors, we say that n is k-composite.

-- Write a function using list comprehension that, given some non-negative k
-- produces the ordered (infinite) list of positive k-composite numbers.

-- [1..INF] -> [[factors], [factors], ...]
-- map "" if length factors - 2 == k

kcomposite ::  Integer -> [Integer]
kcomposite k = [x | x <- [1..], (toInteger (length (factors x) - 2) == k)]

-- Helper function for kcomposite

factors :: Integer -> [Integer] -- from Dr. Shell's slides
factors n = [x | x <- [1..n], mod n x == 0]

-- Here you'll be shuffling whole sentences including the spaces between the words.
-- Given a piece of text, called plaintext, the encoding procedure
-- involves the following steps:
  -- 1. If the number of letters in the plaintext sentence is 2-composite — fine.
  -- 2. If not, take it up to the next 2-composite length by adding X's to the end. This is called padding.
  -- 3. The next step is to arrange the letters in a block. Since there are 21 letters,
    -- and 21 = 3 × 7, we write the letters in 3 rows, with 7 letters in each row.
  -- 4. The message you send comes from reading down the columns:

-- OG sentence -> "" + padding -> [[], ... where the smaller factor of length padded sentence = # of lists]
  -- -> Transposed back into one array

anagramEncode :: [Char] -> [Char]
anagramEncode sentence = writeTransposed (blockedSentence (paddedSentence sentence) (fst (rowsAndCols (toInteger (length (paddedSentence sentence))))) (snd (rowsAndCols (toInteger (length (paddedSentence sentence))))) [] []) []

-- Helper functions for anagramEncode

paddedSentence :: [Char] -> [Char]
paddedSentence xs | elem (toInteger (length xs)) (take (length xs) $ kcomposite 2)   = xs
                  | otherwise                                                        = paddedSentence (xs ++ ['X'])

rowsAndCols :: Integer -> (Integer, Integer)
rowsAndCols x = ((factors x)!!1, (factors x)!!2)

                  -- paddedSentence, rows (small factor), columns (large factor), current row array, template block -> filled block
blockedSentence :: [Char] -> Integer -> Integer -> [Char] -> [[Char]] -> [[Char]]
blockedSentence _ 0 _ _ bs = bs
blockedSentence [z] _ _ ts bs = ((ts ++ [z]):(bs))
blockedSentence (s:ss) r c ts bs | toInteger (length ts) == c   = blockedSentence ss (r - 1) c [s] (ts:bs)
                                 | otherwise                    = blockedSentence ss r c (ts ++ [s]) bs

getHeads :: [[Char]] -> [Char] -- some code borrowed from user Will Gluck on Stack Overflow (searched how to get first element of each list in a list of lists) {https://stackoverflow.com/questions/43869933/list-of-lists-in-haskell-how-can-i-seperate-the-first-element-of-every-list-wi}
getHeads bbs = reverse [head bs | bs <- bbs, not(null bs)]

writeTransposed :: [[Char]] -> [Char] -> [Char]
writeTransposed bbs cs | length (head bbs) == 1       = (cs ++ (getHeads bbs))
                       | otherwise                    = writeTransposed ([tail bs | bs <- bbs, not (null bs)]) (cs ++ (getHeads bbs))


-- Now, implement a function to decrypt messages in the anagram code.
-- (You can assume that the pre-padded plaintext does not end with any X's,
-- so you should strip the trailing padding off the text; the input
-- to the decode has length that is 2-composite.)

-- coded sentence -> small/big factor of length of sentence -> fill small factor rows one time using head -> concatenate rows

anagramDecode :: [Char] -> [Char]
anagramDecode sentence = loseX (readTransposed (intermediateBlock sentence (fst (rowsAndCols (toInteger (length (paddedSentence sentence))))) (snd (rowsAndCols (toInteger (length (paddedSentence sentence))))) [] []) [])

-- Helper functions for anagramDecode

intermediateBlock :: [Char] -> Integer -> Integer -> [Char] -> [[Char]] -> [[Char]]
intermediateBlock _ _ 0 _ bs =  bs
intermediateBlock [z] _ _ ts bs = ((ts ++ [z]):(bs))
intermediateBlock (s:ss) r c ts bs | toInteger (length ts) == r   = intermediateBlock ss r (c - 1) [s] (ts:bs)
                                   | otherwise                    = intermediateBlock ss r c (ts ++ [s]) bs

readTransposed :: [[Char]] -> [Char] -> [Char]
readTransposed bbs cs | length (head bbs) == 1        = cs ++ (getHeads bbs)
                      | otherwise                     = readTransposed ([tail bs | bs <- bbs, not(null bs)]) (cs ++ getHeads bbs)

loseX :: [Char] -> [Char]
loseX (xs) | last xs == 'X'   = loseX (init xs)
           | otherwise        = xs
