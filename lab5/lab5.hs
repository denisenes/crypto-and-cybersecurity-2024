import Data.ByteString.Char8 (pack, unpack)
import qualified Data.ByteString.Base64 as Base64
import qualified Crypto.Hash.SHA256 as SHA256

type User   = String
type Pwd    = String
type PwdMap = [(User, Pwd)]

hashPwd :: Pwd -> String
hashPwd pwd = unpack $ Base64.encode $ SHA256.hash $ pack pwd :: String

addPwd :: User -> Pwd -> PwdMap -> PwdMap
addPwd user pwd pwds = (user, hashPwd pwd) : pwds

authorize :: User -> Pwd -> PwdMap -> Bool
authorize user pwd = any (\(u, p) -> u == user && p == hashPwd pwd)

main :: IO ()
main = do
  let passBase =
        addPwd "denis"   "Pwd123"    $
        addPwd "another" "passpasspass" []

  -- Authorization process
  user <- getLine
  pass <- getLine
  if authorize user pass passBase
      then print "Authorized!"
      else do
            print "Try again"
            main
