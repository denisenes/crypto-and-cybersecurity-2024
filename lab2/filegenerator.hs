import Data.Char     (chr, ord)
import System.IO     (hClose, openFile, IOMode(WriteMode))
import System.Random (randoms, mkStdGen)
import qualified Data.ByteString as BS
import Data.Binary (Word8)

randNums :: [Word8]
randNums = randoms $ mkStdGen 2021 :: [Word8]

onlyA :: BS.ByteString
onlyA = BS.pack (replicate 10000 $ fromIntegral $ ord 'A')

randomBytes :: BS.ByteString
randomBytes = BS.pack (take 10000 randNums)

random0or1  :: BS.ByteString
random0or1  = BS.pack (map (\x -> if even x then 49 else 48) (take 10000 randNums))

main :: IO ()
main = do
    makeFile "onlyA.txt"       onlyA
    makeFile "random0or1.txt"  random0or1
    makeFile "randomASCII.txt" randomBytes
    where
        makeFile :: String -> BS.ByteString -> IO ()
        makeFile filename chars_seq = do
            f <- openFile filename WriteMode
            BS.hPutStr f chars_seq
            hClose f
