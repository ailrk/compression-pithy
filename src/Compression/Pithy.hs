module Compression.Pithy where


import Compression.Internal
import qualified Data.ByteString as BS

import GHC.IO (unsafePerformIO)

data CompressionLevel
  = L1 | L2 | L3 | L4 | L5 | L6 | L7 | L8 | L9 | L10 deriving (Eq, Show, Enum)


compress :: CompressionLevel -> BS.ByteString -> BS.ByteString
compress level uncompressed =
  unsafePerformIO $ compress' ((+1) . fromIntegral . fromEnum $ level) uncompressed


decompress :: BS.ByteString -> BS.ByteString
decompress = unsafePerformIO . decompress'
