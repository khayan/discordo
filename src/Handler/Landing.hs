{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Landing where

import Import
import Data.FileEmbed(embedFile)
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql
import Settings.StaticFiles

getLandingR :: Handler Html
getLandingR = do 
    defaultLayout $ do 
        toWidgetHead [hamlet|
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        |]
        setTitle "Discordo!"
        toWidgetHead $(luciusFile "templates/landing.lucius")
        $(whamletFile "templates/landing.hamlet")