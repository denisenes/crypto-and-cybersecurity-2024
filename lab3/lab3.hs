import System.Environment
import Data.Bits
import Data.ByteString             as BS
import qualified Crypto.Cipher.RC4 as RC4

vernamCipher :: ByteString -> ByteString -> ByteString
vernamCipher message key = BS.pack $ BS.zipWith xor message key

rc4Cipher :: ByteString -> ByteString -> ByteString
rc4Cipher message key =
    let ctx = RC4.initCtx key in
    snd $ RC4.combine ctx message 

main :: IO ()
main = do
    [cipher, messageFName, keyFNname, outFName] <- getArgs
    message <- BS.readFile messageFName
    key     <- BS.readFile keyFNname
    let encryptedMessage = case cipher of
            "vernam" -> vernamCipher message key
            "rc4"    -> rc4Cipher    message key
    BS.writeFile outFName encryptedMessage