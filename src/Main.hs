{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import DBus.Notify
import System.Info (os)


import Data.Aeson
import Data.Proxy
import GHC.Generics
import           Network.HTTP.Client.TLS (newTlsManager)
import Servant.API
import Servant.Client
import Servant.Types.SourceT (foreach)
import qualified Servant.Client.Streaming as S


data RatpSchedule = RatpSchedule
    {
        destination :: String,
        message     :: String
    }
    deriving (Show, Generic)
instance FromJSON RatpSchedule

data RatpResult = RatpResult
    {
        schedules :: [RatpSchedule]
    }
    deriving (Show, Generic)
instance FromJSON RatpResult

data RatpMetadata = RatpMetadata
    {
        call    :: String,
        date    :: String,
        version :: Int
    }
    deriving (Show, Generic)
instance FromJSON RatpMetadata

data RatpResponse = RatpResponse
    {
        _metadata :: RatpMetadata,
        result    :: RatpResult
    }
    deriving (Show, Generic)
instance FromJSON RatpResponse

type TranportType = String
type LigneCode = Int
type StationName = String
type Direction = String

type RatpAPI = "schedules"
                :> Capture "type" TranportType
                :> Capture "code" LigneCode
                :> Capture "station" StationName
                :> Capture "way" Direction
                :> Get '[JSON] RatpResponse


api :: Proxy RatpAPI
api = Proxy

schedules' :: TranportType -> LigneCode -> StationName -> Direction -> ClientM RatpResponse
schedules' = client api

queries :: TranportType -> LigneCode -> StationName -> Direction -> ClientM RatpResponse
queries type' code station way = schedules' type' code station way


notifyPopup :: String -> String -> IO ()
notifyPopup title msg =
  case os of
      "linux" -> do
        client <- connectSession
        let startNote = appNote { summary= title, body=Just $ Text msg}
        notify client startNote
        return ()
      _ -> return ()
    where
        appNote = blankNote { appName="ZuriHac_2019" }


sendInfo :: RatpResult -> TranportType -> LigneCode -> StationName -> IO()
sendInfo res type' code station = notifyPopup title msg
            where
                title = type' ++ " " ++ show code ++ " on station " ++ station ++ " to " ++ (destination $ schedules res !! 0)
                msg = "info : " ++ (message $ schedules res !! 0)

exec :: TranportType -> LigneCode -> StationName -> Direction -> IO()
exec type' code station way = do
    manager' <- newTlsManager
    res <- runClientM (queries type' code station way) (mkClientEnv manager' (BaseUrl Http "api-ratp.pierre-grimaud.fr" 80 "v4"))
    case res of
        Left err  -> putStrLn $ "Error: " ++ show err
        Right ret -> sendInfo (result ret) type' code station

main :: IO ()
main = do
    putStrLn "Hello, Haskell!"
