import Codec.BMP
import qualified Data.ByteString as BS
import Data.Word
import Data.Bits
import Data.Char (ord, chr)
import System.Environment

splitEvery :: Int -> [a] -> [[a]]
splitEvery _ [] = []
splitEvery n xs = as : splitEvery n bs where (as,bs) = splitAt n xs

int2bits :: Int -> [Word8]
int2bits c = int2bits0 8 [] c
    where
        int2bits0 0 acc _ = acc
        int2bits0 i acc c = int2bits0 (i - 1) (fromIntegral (c .&. 1) : acc) (shiftR c 1)

bits2int :: [Word8] -> Int
bits2int ws = bits2int0 0 ws
    where
        bits2int0 acc [] = fromIntegral $ toInteger (acc `shiftR` 1)
        bits2int0 acc (w:ws) = let nacc = shift (acc .|. w) 1 in bits2int0 nacc ws

enrich :: [Word8] -> String -> [Word8]
enrich bmp message =
    let m  = message ++ "#" in
    let mb = concatMap (int2bits . ord) m in
    zipIfPossible bmp mb
    where
        zipIfPossible [] [] = []
        zipIfPossible ws [] = ws
        zipIfPossible [] ms = error "Message is larger than container"
        zipIfPossible (w:ws) (b:bs) = ((w .&. complement 1) .|. b) : zipIfPossible ws bs

extract :: [Word8] -> String
extract bmp =
    let rbmp = bmp in
    let gs = splitEvery 8 (map (.&.1) rbmp) in
    let res = map (chr . bits2int) gs in
    getMsg res
        where
            getMsg [] = []
            getMsg (x:xs) = if x == '#' then [] else x : getMsg xs

main = do
    [file, mode] <- getArgs
    Right bmp  <- readBMP file
    let rgba   =  BS.unpack $ unpackBMPToRGBA32 bmp
    let (width, height) = bmpDimensions bmp
    print ("BMP image " ++ show width ++ "x" ++ show height)
    case mode of
        "enc" -> do
            msg <- getLine
            let enriched = enrich rgba msg
            let bmp    = packRGBA32ToBMP width height (BS.pack enriched)
            writeBMP "res.bmp" bmp
        "dec" -> do
            let message = extract rgba
            print (take 50 message)