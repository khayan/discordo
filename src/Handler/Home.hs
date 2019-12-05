{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Data.FileEmbed(embedFile)
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Settings.StaticFiles

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $ do 
        toWidgetHead $(luciusFile "templates/default-layout.lucius")
        setTitle "Discordo!"
        addStylesheetRemote "https://fonts.googleapis.com/css?family=Anton&display=swap"
        addScriptRemote "https://code.jquery.com/jquery-1.12.0.min.js"
        addScript $ StaticR js_scroll_js
        addStylesheet $ StaticR css_reset_css
        addStylesheet $ StaticR css_estilo_css
        $(whamletFile "templates/header.hamlet")
        $(whamletFile "templates/index.hamlet")

getContatoR :: Handler Html
getContatoR = do
    defaultLayout $ do 
        toWidgetHead $(juliusFile "templates/teste.julius")
        toWidgetHead $(luciusFile "templates/default-layout.lucius")
        $(whamletFile "templates/footer.hamlet")