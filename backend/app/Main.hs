{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main (main) where

import Web.Scotty
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as BS
import Data.Aeson (FromJSON, ToJSON)
import Data.Csv (FromNamedRecord, parseNamedRecord, (.:), decodeByName)
import GHC.Generics (Generic)
import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V
import qualified Data.Map.Strict as M
import Data.List (foldl')
import Network.Wai.Middleware.Cors
  ( cors,
    corsRequestHeaders,
    simpleCorsResourcePolicy,
    CorsResourcePolicy (..)
  )
import Network.Wai (Middleware)

-- Data type representing a person
data Person = Person
    { firstName   :: !Text
    , lastName    :: !Text
    , companyName :: !Text
    , address     :: !Text
    , city        :: !Text
    , county      :: !Text
    , state       :: !Text
    , zipCode     :: !Text  -- zip is a reserved keyword. Use zipCode instead.
    , phone1      :: !Text
    , phone2      :: !Text
    , email       :: !Text
    , web         :: !Text
    } deriving (Show, Generic)

instance FromJSON Person
instance ToJSON Person

-- Parsing CSV records into Person data type
instance FromNamedRecord Person where
    parseNamedRecord r = Person
        <$> r .: "first_name"
        <*> r .: "last_name"
        <*> r .: "company_name"
        <*> r .: "address"
        <*> r .: "city"
        <*> r .: "county"
        <*> r .: "state"
        <*> r .: "zip"
        <*> r .: "phone1"
        <*> r .: "phone2"
        <*> r .: "email"
        <*> r .: "web"

-- Data type for search requests
data SearchRequest = SearchRequest
    { searchField :: !Text
    , targetValue :: !Text
    } deriving (Show, Generic)

instance FromJSON SearchRequest

-- Function to get the value of a specified field from a Person
getFieldValue :: Text -> Person -> Text
getFieldValue field person
    | field == "firstName"   = firstName person
    | field == "lastName"    = lastName person
    | field == "companyName" = companyName person
    | field == "address"      = address person
    | field == "city"         = city person
    | field == "county"       = county person
    | field == "state"        = state person
    | field == "zipCode"      = zipCode person
    | field == "phone1"       = phone1 person
    | field == "phone2"       = phone2 person
    | field == "email"        = email person
    | field == "web"          = web person
    | otherwise               = ""

main :: IO ()
main = do
    -- Read the CSV file
    csvData <- BL.readFile "app/data/us-500.csv"
    case decodeByName csvData of
        Left err -> putStrLn err
        Right (_, persons) -> do
            let personList = V.toList persons

            -- Set up CORS policy
            let origins = [ "http://localhost:5173"
                        , "http://192.168.0.196:5173"
                        , "https://dashboard-haskell-react.qingquanli.com"
                        ]
            let corsPolicy :: CorsResourcePolicy
                corsPolicy = simpleCorsResourcePolicy
                    { corsOrigins = Just (map BS.pack origins, True)
                    , corsMethods = ["GET", "POST", "OPTIONS"]
                    , corsRequestHeaders = ["Content-Type"]
                    }
            let corsMiddleware :: Middleware
                corsMiddleware = cors (const $ Just corsPolicy)

            -- Start Scotty server
            scotty 8080 $ do
                middleware corsMiddleware

                -- GET /api/data endpoint
                get "/api/data" $ do
                    json personList

                -- POST /api/search endpoint
                post "/api/search" $ do
                    req <- jsonData :: ActionM SearchRequest
                    let field = searchField req
                        value = targetValue req
                        filteredPersons = filter (\p -> T.toLower (getFieldValue field p) == T.toLower value) personList
                    json filteredPersons

                -- GET /api/num-of-people-per-state endpoint
                get "/api/num-of-people-per-state" $ do
                    let counts = foldl' (\acc p -> M.insertWith (+) (state p) (1 :: Int) acc) M.empty personList
                    json counts
