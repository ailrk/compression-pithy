{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
module Compression.Raw where


import Foreign
import Foreign.C.Types

-- compressionLevel >= 0 && compressionLevel <= 9.  Values out side this range will be clamped to this range.

foreign import capi "pithy.h pithy_Compress" c_pithy_Compress
  :: Ptr CChar
  -- ^ uncompressed
  -> CSize
  -- ^ uncompressedLength
  -> Ptr CChar
  -- ^ compressedOut
  -> CSize
  -- ^ compressedOutLength
  -> CInt
  -- ^ compressionLevel
  -> IO CSize

foreign import capi "pithy.h pithy_Decompress" c_pithy_Decompress
  :: Ptr CChar
  -- ^ compressed
  -> CSize
  -- ^ compressedLength
  -> Ptr CChar
  -- ^ compressedOut
  -> CSize
  -- ^ compressedOutLength
  -> IO CInt

foreign import capi "pithy.h pithy_MaxCompressedLength" c_pithy_MaxCompressedLength
  :: CSize
  -- ^ inputLength
  -> IO CSize

foreign import capi "pithy.h pithy_GetDecompressedLength" c_pithy_GetDecompressedLength
  :: Ptr CChar
  -- ^ compressed
  -> CSize
  -- ^ compressedLength
  -> Ptr CSize
  -- ^ decompressedOutLengthResult
  -> IO CInt
