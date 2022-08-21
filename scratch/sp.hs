module Sp (SingleOrPair(Single, Pair), checkEq) where

data SingleOrPair a = Single a | Pair a a

checkEq :: (Eq a) => (SingleOrPair a) -> (SingleOrPair a) -> Bool
checkEq (Single x) (Single y) = (x == y)
checkEq (Single x) (Pair y _) = (x == y)
checkEq u v = checkEq v u
