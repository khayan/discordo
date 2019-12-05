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
    maybeNome <- lookupSession "Nome"
		login <- case maybeNome of
						(Just login) -> do
								return login
						_ -> do
								redirect HomeLoginR
    defaultLayout $ do 
        setTitle "Discordo!"
        addStylesheetRemote "https://fonts.googleapis.com/css?family=Anton&display=swap"
        addScriptRemote "https://code.jquery.com/jquery-1.12.0.min.js"
        addStylesheet $ StaticR css_reset_css
        addStylesheet $ StaticR css_estilo_css
        $(whamletFile "templates/header.hamlet")