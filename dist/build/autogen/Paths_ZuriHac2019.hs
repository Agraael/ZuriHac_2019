{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_ZuriHac2019 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/kraken/.cabal/bin"
libdir     = "/home/kraken/.cabal/lib/x86_64-linux-ghc-8.0.2/ZuriHac2019-0.1.0.0-4H9Eqnk04WPCLjYS4bKp7h"
dynlibdir  = "/home/kraken/.cabal/lib/x86_64-linux-ghc-8.0.2"
datadir    = "/home/kraken/.cabal/share/x86_64-linux-ghc-8.0.2/ZuriHac2019-0.1.0.0"
libexecdir = "/home/kraken/.cabal/libexec"
sysconfdir = "/home/kraken/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ZuriHac2019_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ZuriHac2019_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "ZuriHac2019_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "ZuriHac2019_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ZuriHac2019_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ZuriHac2019_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
