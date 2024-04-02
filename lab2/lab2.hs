import qualified Data.Map as Map
import qualified Data.ByteString as BS
import System.Environment (getArgs)

entropy :: [Int] -> Double
entropy bytes =
    let len = fromIntegral $ length bytes in
    sum $ map (\x -> let p_i = fromIntegral x / len in -p_i * logBase 2 p_i) freqs
  where
    freqs = map snd
        $ Map.toList
        $ foldl (\m x -> Map.insertWith (+) x 1 m) Map.empty bytes

calculateEntropy :: FilePath -> IO ()
calculateEntropy filePath = do
    byte_sequence <- BS.readFile filePath
    let content = map fromIntegral $ BS.unpack byte_sequence 
    let ent = entropy content
    putStrLn $ "Entropy of " ++ filePath ++ " = " ++ show ent

main :: IO ()
main = do
    args <- getArgs
    let fileName = head args
    calculateEntropy fileName
