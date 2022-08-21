{-

CSCE 314-500
Sachin Chanchani (828004948)
Graded Programming Assignment 3

-}

-- The following problems are to implement mathematical sets and some of their
-- operations using Haskell lists. A set is an unordered collection of elements
-- (objects) without duplicates, whereas a list is an ordered collection of
--   elements in which multiplicity of the same element is allowed.

-- We do not define a new type for sets, but instead define Set as a type synonym
-- for lists as follows:
    -- Note: if your type definitions have the extra
    -- class constraint: (Ord a) => ... for any of the solutions
    -- given below, that is acceptable too.

type Set a = [a]

-- helper functions for Sets
len :: Set a -> Integer
len [] = 0
len [z] = 1
len (s:ss) = 1 + len ss

-- The partition of a set S is defined as a set of
--   nonempty, pairwise disjoint subsets of S whose
--   union is S. For example, the set
--   {red, green, blue} can be partitioned
--   in 5 ways:
--     { {red}, {green}, {blue} }
--     { {red}, {green, blue} }
--     { {green}, {red, blue} }
--     { {blue}, {red, green} }
--     { {red, green, blue} }.

-- Set partition algorithm (as described in https://wiki.haskell.org/wikiupload/d/dd/TMR-Issue8.pdf)
    -- choose an arbitrary element s ∈ S;
    -- generate the power set (set of all subsets) of S - s;
      -- each one of these subsets can be combined with s
      -- and a partition of the remaining elements to form a partition of S

-- That is, for each T ⊆ (S \ {s}),
              -- recursively find the partitions of S \ ({s} ∪ T), and add
              -- {s} ∪ T to each to form a partition of S.

-- set of nonempty, pairwise disjoint subsets of S whose union is S
    -- this means the concatenation of pairwise disjoint subsets of S in one element (set) of the partition
    -- should be the same set as S

powerSet :: Set a -> Set (Set a) -- helper function (as described in http://www.multiwingspan.co.uk/haskell.php?page=power)
powerSet [] = [[]]
powerSet [x] = [[x], []]
powerSet (s:ss) = map (s:) (powerSet ss) ++ powerSet ss

powerSetCompl :: Set a -> Set (Set a)
powerSetCompl [] = [[]]
powerSetCompl [x] = [[], [x]]
powerSetCompl (s:ss) = reverse $ map (s:) (powerSet ss) ++ powerSet ss

-- for each subset si in the powerset of S:
    -- if first one: mkSet and add to set of partitions
    -- if length of si is 1:
        -- for each remaining subset sj in the powerset of S:
            -- if the length of sj is also 1, add it to Set with si
        -- return Set of n sets | length is 1
    -- if non-empty:
        -- for each remaining subset sj in the powerset of S:
            -- if sj complements si to form S and si not a subset of sj:
                -- Add {si, sj} to set of partitions

        -- for each set of pairs of remaining subsets {sj, sk}:
            -- if concatenation of sj and sk complements si to form S and si not a subset of concat:
                -- Add {si, {sj, sk}} to set of partitions

-- for each subset si and its complement ci in the powerset of S:
    -- if [si:ci] not in partitions, add to partitions
  -- recursively do this loop but from 1..

-- partitionHelper :: Set t -> Set (Set t) -> Set (Set (Set t)) -> Set (Set (Set t))
-- partitionHelper [s] (p:ps) ret =
--                                   let y =
--
--
-- partitionSet :: Eq t => Set t -> Set ( Set (Set t))
-- partitionSet [x] = [[]]
-- partitionSet (s:ss) |

partitionHelper :: Eq t => Set (Set t) -> Set (Set t) -> Set (Set (Set t)) -> Set (Set (Set t))
partitionHelper [[]] [[]] r                                                   = r
partitionHelper [x] [xc] r        | not (elem ((mkSet ((x) : ([xc])))) (r))   = (mkSet (((mkSet ((x) : ([xc]))))) : ([]))
partitionHelper (p:ps) (rp:rps) r | not (elem ((mkSet ((p) : ([rp])))) (r))   = ((mkSet ((mkSet ((p) : ([rp]))))) : ([])) ++ (partitionHelper (mkSet ps) (mkSet rps) (r)) ++ (partitionHelper (powerSet p) (powerSet rp) ([[]]))
                                  | otherwise                                 = (partitionHelper (mkSet ps) (mkSet rps) (r)) ++ (partitionHelper (powerSet p) (powerSet rp) ([[]]))



-- Set contstructor from list (remove duplicates)

mkSet :: Eq a => [a] -> Set a
mkSet [] = []
mkSet [z] = [z]
mkSet (y:ys) | elem y ys  = mkSet ys
             | otherwise  = (mkSet [y]) ++ (mkSet ys)

-- Write a recursive function subset, such that subset
-- set1 set2 returns True if set1 is a subset of set2
-- and False otherwise.
-- if all elements in set1 exist in set2, return True else False

subset :: Eq a => Set a -> Set a -> Bool
subset [] _ = True
subset [s] s2 = elem s s2
subset (s:s1) s2 | not (elem s s2) = False
                 | otherwise = subset s1 s2

-- Using subset you have already defined, write a function
-- setEqual that returns True if the two sets contain
-- exactly the same elements, and False otherwise.

setEqual :: Eq a => Set a -> Set a -> Bool
setEqual [] [] = True
setEqual s1 s2 = (len s1 == len s2) && (subset s1 s2)

-- The product of two sets A and B is the set consisting of all pairs
-- draw from either set, where the pairs are ordered having
-- elements (ai, bj). The first element is from A and the second from B.

setProd :: (Eq t, Eq t1) => Set t -> Set t1 -> Set (t, t1)
setProd [] [] = []
setProd s1 s2 = [(x, y) | x <- s1, y <- s2]
