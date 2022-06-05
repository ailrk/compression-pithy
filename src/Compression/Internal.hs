module Compression.Internal where

import Compression.Raw
import qualified Data.ByteString as BS
import Foreign.Marshal.Alloc
import Foreign.C.String
import Foreign


compress' :: Integer -> BS.ByteString -> IO BS.ByteString
compress' compressionLevel uncompressed =
  BS.useAsCStringLen uncompressed $ \(uncompressedPtr, uncompressedLen) -> do
    maxCompressedLen <- c_pithy_MaxCompressedLength (fromIntegral uncompressedLen)
    outPtr <- mallocBytes (fromIntegral maxCompressedLen)
    n <- c_pithy_Compress
            uncompressedPtr
            (fromIntegral uncompressedLen)
            outPtr
            maxCompressedLen
            (fromIntegral compressionLevel)
    BS.packCStringLen (outPtr, fromIntegral n)


decompress' :: BS.ByteString -> IO BS.ByteString
decompress' compressed =
  BS.useAsCStringLen compressed $ \(compressedPtr, compressedLen) -> do
    alloca $ \outDecompressLenPtr -> do
      errMsg <- c_pithy_GetDecompressedLength
                  compressedPtr
                  (fromIntegral compressedLen)
                  outDecompressLenPtr
      outDecompressLen <- peek outDecompressLenPtr
      outPtr <- mallocBytes (fromIntegral outDecompressLen)
      n <- c_pithy_Decompress
            compressedPtr
            (fromIntegral compressedLen)
            outPtr
            outDecompressLen
      BS.packCStringLen (outPtr, fromIntegral outDecompressLen)
