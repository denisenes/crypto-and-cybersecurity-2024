import qualified Data.Map as M

data Entity =
    RootCertCenter |
    CertCenter Int |
    User Int
    deriving (Show, Eq, Ord)

makeTrustChain :: M.Map Entity Entity -> Entity -> [Entity]
makeTrustChain hm RootCertCenter = []
makeTrustChain hm who = 
    case M.lookup who hm of
        Nothing -> error "Didn't find path"
        Just v  -> who : makeTrustChain hm v

main :: IO ()
main = do
    let db = M.fromList [
            (CertCenter 1, RootCertCenter),
            (CertCenter 2, RootCertCenter),
            (CertCenter 3,   CertCenter 1),
            (CertCenter 4,   CertCenter 1),
            (CertCenter 5,   CertCenter 2),
            (CertCenter 6,   CertCenter 2),
            (User 1,         CertCenter 3),
            (User 2,         CertCenter 4),
            (User 3,         CertCenter 4),
            (User 4,         CertCenter 5),
            (User 5,         CertCenter 6),
            (User 6,         CertCenter 6)
            ]
    print (makeTrustChain db (User 5))
    