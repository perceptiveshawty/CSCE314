{-

Q1: Compound Interest

-}

-- Lam Nguyen  2 hours ago
-- how to round a value located in an index of a list. this rounds to hundreds place. feel free to change it if needed
-- fromIntegral (round $ (lst !! index) * 1e2) / 1e2)

-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- it takes the second argument and the last item of the list and applies the
-- function, then it takes the penultimate item from the end and the result,
-- and so on. See scanr for intermediate results.

-- 1.1
compoundReturn :: Floating a => (a -> (a -> [a]))
compoundReturn i r = [(i * ((1 + (r/100)) ^ x)) | x <- [0..]]

-- 1.2
showOnlyEvery :: Int -> [b] -> [(Int, b)]
showOnlyEvery m ls = zip (iterate (m+) 0) [ls !! i | i <- [0..], (i `mod` m == 0)]

-- 1.3
compoundReturn' :: Floating a => (a -> (a -> [a]))
compoundReturn' i r = foldr f [] [0..]
                        where f x y = (i * ((1 + (r/100)) ^ x)) : y
