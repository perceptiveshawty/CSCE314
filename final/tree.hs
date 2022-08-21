{-
    Mon 29 Mar 2021 09:35:51 AM CDT
-}

--     (4 + 5) * (3 + 4) + 10

{-

            +
          /   \
         /    10
        *
       / \
      /   \
     +     +
    / \   / \
   4   5 3   4
-}

data Expr a = Val a  | Add (Expr a) (Expr a) | Mul (Expr a) (Expr a)
    deriving (Show)


s0 = Add (Val 4) (Val 5.0)
s1 = Add (Val 3) (Val 4)
t1 =  Mul (s0) (s1)
l = Add t1 (Val 10)

l' = Add (Val "Hello") (Val "World")

printExpr :: (Show a) => Expr a -> String
printExpr (Val x) = (show x)
printExpr (Add x y) = "(" ++ (printExpr x) ++ " + " ++ (printExpr y) ++ ")"
printExpr (Mul x y) = "(" ++ (printExpr x) ++ " * " ++ (printExpr y) ++ ")"

eval :: (Num a) => Expr a -> a
eval (Val x) = x
eval (Add x y) = (eval x) + (eval y)
eval (Mul x y) = (eval x) * (eval y)

printExprPre :: (Show a) => Expr a -> String
printExprPre (Val x) = (show x) ++ " "
printExprPre (Add x y) =  " + " ++ (printExprPre x) ++ (printExprPre y)
printExprPre (Mul x y) =  " * " ++ (printExprPre x) ++ (printExprPre y)

printExprPost :: (Show a) => Expr a -> String
printExprPost (Val x) = " " ++ (show x)
printExprPost (Add x y) =  (printExprPost x) ++ (printExprPost y) ++ " + "
printExprPost (Mul x y) =  (printExprPost x) ++ (printExprPost y) ++ " * "
