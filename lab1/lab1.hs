module Lab1 (
    encryptCaesar,
    decryptCaesar,
    attackByOpenText,
    attackByBrutforce,
    attackUsingDictionary
) where
    
import Data.Char
import Data.List (elemIndex, isPrefixOf, tails)
import Data.Maybe (fromJust)

alphabet = ['A' .. 'Z']
alphabetSize = length alphabet

inAlpha :: Char -> Bool
inAlpha c = c `elem` alphabet

char2num :: Char -> Int
char2num c = fromJust $ elemIndex c alphabet

num2char :: Int -> Char
num2char n = alphabet !! n

-- Task 1 --

encryptCaesar :: Int -> String -> String
encryptCaesar shift = map (\c ->
    if inAlpha c
        then shiftChar c
        else error "Symbol is not from alphabet")
  where
    shiftChar :: Char -> Char
    shiftChar c = num2char ((char2num c + shift) `mod` alphabetSize)

decryptCaesar :: Int -> String -> String
decryptCaesar shift = encryptCaesar (-shift)

-- Task 2 --

attackByOpenText :: String -> String -> Int
attackByOpenText enc src =
    let res = [s | s <- [0..alphabetSize-1], encryptCaesar s src == enc] in
    case res of
        [] -> error "Could not find key"
        _ -> head res

-- Task 3 --

attackByBrutforce :: String -> [(Int, String)]
attackByBrutforce enc = [(shift, decryptCaesar shift enc) | shift <- [0..alphabetSize-1]]

-- Task 4 --

dictionary = ["HELLO", "THE", "HUMAN", "GET", "ANOTHER", "PANTS"]

contains :: String -> String -> Bool
contains str substr = any (isPrefixOf substr) (tails str)

attackUsingDictionary :: String -> [(Int, String)]
attackUsingDictionary enc =
    let variants = attackByBrutforce enc in
    filter (\(k, s) -> containsAnyFromDict s) variants
    where
        containsAnyFromDict :: String -> Bool
        containsAnyFromDict str = any (\s -> str `contains` s) dictionary