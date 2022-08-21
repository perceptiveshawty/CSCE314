type Parser a = String -> [(a, String)]

item :: Parser Char
item = \inp -> case inp of
    []     -> []
    (x:xs) -> [(x,xs)]
