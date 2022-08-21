{-
HW3 - Extra Credit Submission
Sachin Chanchani
828004948
-}

-- given a list, reverse it. (recursive)
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

-- judge if a value is an element of a list.
  -- If it is, return True,
  -- else return False. (recursive)

isElement :: Eq a => a -> [a] -> Bool
isElement _ [] = False
isElement y (x:xs) = if y == x then True else isElement y xs

-- duplicate the elements of a list. For example,
-- duplicate [1,2] returns [1,1,2,2]. (recursive)

duplicate :: [a] -> [a]
duplicate [] = []
duplicate (x:xs) = x:x:duplicate xs

-- given a sorted list, remove the duplicated elements
-- in this list. (recursive)

removeDuplicate :: Eq a => [a] -> [a]
removeDuplicate [] = []
removeDuplicate (x:[]) = [x]
removeDuplicate (w:x:[]) = if (x == w) then [x] else [w] ++ [x]
removeDuplicate (x:xs) = if (x == head xs) then removeDuplicate xs
                        else x:removeDuplicate xs

-- rotate a list n places to the left, where n
-- is an integer. For example, rotate "abcde" 2
-- returns "cdeab".

rotate :: [a] -> Integer -> [a]
rotate [] _ = []
rotate ls 0 = ls
rotate (x:xs) n = rotate (xs ++ [x]) (n - 1)

-- flatten: flatten a list of lists into a single list
-- formed by concatenation.

flatten :: [[a]] -> [a]
flatten [x] = x
flatten (x:xs) = x ++ (flatten xs)

-- isPalindrome : given a list, jusdge if it is a palindrome
isPalindrome :: Eq a => [a] -> Bool
isPalindrome ls = (ls == reverse ls)

-- coprime: given two positive integer numbers,
-- determine whether they are coprime. Two numbers
-- are coprime if their greatest common divisor equals 1.

coprime :: Integer -> Integer -> Bool
coprime x y = (gcd' x y == 1)

gcd' :: Integer -> Integer -> Integer
gcd' a b | (a == 0) = b
         | (b == 0) = a
         | otherwise = gcd' b r
         where r = a `mod` b

-- The input of the function consists of two strings.
-- The first string is the "aaaah" the doctor needs and
-- the second string is the "aah" we are able to say.
-- Output "True" if our "aah" meets the requirements
-- of the doctor, and output "False" otherwise.
-- The test should pass with a "True" only when lowercase
-- 'a's and 'h's are used, and each string contains a
-- certain number of 'a's followed by a single 'h'

seeDoctor :: String -> String -> Bool
seeDoctor [] [] = True
seeDoctor d [] = False
seeDoctor [] m = if (not (elem 'h' m)) then False else True
seeDoctor d m | length m < length d = False
              | length (filter (=='h') (m)) > 1 || length (filter (=='h') (d)) > 1 = False
              | not (last (m) == 'h') = False
              | not (last (d) == 'h') = False
              | length (filter (notVal) (m)) > 0 = False
              | length (filter (notVal) (d)) > 0 = False
              | (not (elem 'h' (d))) || (not (elem 'h' (m))) = False
              | length (filter (=='a') d) <= length (filter (=='a') m) = True

notVal n = (n /= 'a' && n /= 'h') --helper for seeDoctor

-- There are n water gates in a reservoir that are
-- initially closed. To adjust water in the reservoir,
-- we open/close the water gates according to the
-- following rule: on the first day, we open all
-- the gates. Then, on the second day, we close
-- every second gate. On the third day, we change
-- the state of every third gate (open it if
-- it's closed or close it if it's open) ...
-- For the ith day, we change the state of every i gate.
-- Finally, for the nth day, we change the
-- state of the last gate. Our question is,
-- how many gates are open after n days?

-- this problem really makes me wish I would just draw out recursion before trying to code it
-- excellent trick question

waterGate :: Int -> Int
waterGate 0 = 0
waterGate 1 = 1
waterGate n = length (takeWhile (<=n) [i*i | i <- [1..]])


-- Goldbach's other conjecture: Christian Goldbach once proposed
-- that every odd composite number can be written as the
-- sum of a prime and twice a square. For example,

-- goldbachNum :: Int
-- goldbachNum is such that (n - p)/2 * k = k  === n = p + 2k^2

-- generate a list of primes and check if difference between any odd composite no. and prime number
-- is equivalent to twice a perfect square

-- functions needed -
  -- infinite list of primes
  -- infinite list of odd composite numbers
  -- isHalfTheDiffAPerfectSquare?

goldbachnum :: Int
goldbachnum = head [n | n <- odds, (null (goldbachfor n))]

goldbachfor :: Int -> [(Int, Int)]
goldbachfor n = [(p, floor (sqrt (fromIntegral s))) | p <- takeWhile (<n) primes, let s = (n - p) `div` 2, isIt s]

primes :: [Int]
primes = filter (\x -> (length (factors x) == 2)) [4..]
factors n = [x | x <- [1..n], mod n x == 0] -- Helper function for primes from Dr. Shell's slides

odds :: [Int]
odds = filter (\x -> (length (factors x) > 2)) [3, 5..]

isIt :: Int -> Bool
isIt n = (floor (sqrt (fromIntegral n))) ^ 2 == n


-- UNUSED / GARBAGE CODE --

-- halveddifferences = takeWhile (isIt) (map (\x -> x `div` 2) (liftM2 (-) odds primes))

-- isHalfTheDiffAPerfectSquare d = = (elem d (takeWhile (<=d) [i*i | i <- [1..]]))

-- goldbachnum = let run = [n | n <- odds] in
--                 takeWhile (goldbachfor n)
-- kcomposite ::  Integer -> [Integer]
-- kcomposite k = [x | x <- [1..], (toInteger (length (factors x) - 2) == k)]


-- waterGateN :: Int -> [Bool]
-- waterGateN n | n (foldr reverseEveryI (replicate n False) [1..n]) - 1
--              | otherwise = (foldr reverseEveryI (replicate n False) [1..n]) + 1
-- --
-- reverseEveryI i bs = zip revK [1..]
--                     where revK n b | n `mod` i == 0 = not b
--                                    | otherwise = b
--

--
-- waterGateN bs i n | (i == n) = (init bs) ++ [not (last bs)]
--                   | otherwise = waterGateN ts (i + 1) n
--                   where ts = map (\b -> if )
--
--                         -- | (i == n) = waterGateN (i - 1) n n
--                         -- | (i == (n - 1)) = waterGateN (i - 1) n (n `div` 2)
--
-- -- waterGate2 :: [Bool] -> [Bool]
-- -- waterGate2 (b1:b2:[]) = b1:[False]
-- waterGate2 (b1:[]) = b1:[]
-- waterGate2 (b1:b2:bs) = b1:[False] ++ waterGate1 bs

-- waterGateN :: Int -> Int -> [Bool] -> [Bool] -> Int
-- waterGateN 0 n = waterGateN 2 n (waterGate2 (replicate n True))
-- waterGateN 2 n

-- seeDoctor ['a'] ['h'] = False
-- seeDoctor ['h'] ['a'] = True
-- seeDoctor (d:ds) (m:ms) | length (filter (/='h') (m:ms)) > 1 || length (filter (/='h') (d:ds)) > 1 = False
--                         | not (last (m:ms) == 'h') = False
--                         | not (last (d:ds) == 'h') = False
--                         | length (filter (notVal) (m:ms)) > 0 = False
--                         | length (filter (notVal) (d:ds)) > 0 = False
--                         | (not (elem 'h' (d:ds))) || (not (elem 'h' (m:ms))) = False
--                         | (d == 'a') && (m == 'a') = seeDoctor ds ms
--                         | (d == 'h') && (m == 'h') = True
--                         | (d == 'a') && (m == 'h') = False
--                         | (d == 'h') && (m == 'a') = True
