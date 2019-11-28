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

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $ do 
        toWidgetHead $(luciusFile "templates/default-layout.lucius")
        $(whamletFile "templates/aaa.hamlet")
        
getContatoR :: Handler Html
getContatoR = do 
    defaultLayout $ do 
        toWidgetHead $(juliusFile "templates/teste.julius")
        toWidgetHead $(luciusFile "templates/default-layout.lucius")
        $(whamletFile "templates/contato.hamlet")