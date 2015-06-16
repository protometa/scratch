
doubleMe x = x + x 

doubleUs x y = doubleMe x + doubleMe y

doubleSmall x = if x > 100 then x else doubleMe x

maximum' :: (Ord a) => [a] -> a  
maximum' [] = error "maximum of empty list"  
maximum' [x] = x  
maximum' (x:xs)   
    | x > maxTail = x  
    | otherwise = maxTail  
    where maxTail = maximum' xs


quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
    let bigger = quicksort (filter (>x) xs)
        smaller = quicksort (filter (<=x) xs)
    in smaller ++ [x] ++ bigger

chain :: Integral a => a -> [a]
chain 1 = [1]
chain n
    | even n = n : chain (n `div` 2)
    | odd n = n : chain (n*3 + 1)

