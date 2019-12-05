{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Cadastro where

import Import
import Data.FileEmbed(embedFile)
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql
import Settings.StaticFiles

getCadastrarR :: Handler Html
getCadastrarR = do 
    defaultLayout $ do 
        toWidgetHead [hamlet|
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        |]
        setTitle "Discordo! | Cadastro"
        toWidgetHead $(luciusFile "templates/cadastro.lucius")
        $(whamletFile "templates/cadastro.hamlet")
        
postCadastrarR :: Handler Html
postCadastrarR = do
    username <- runInputPost $ ireq textField "username"
    senha <- runInputPost $ ireq textField "senha_cad"
    userId <- runDB $ insert $ Usuario username senha
    defaultLayout $ do
        $(whamletFile "templates/cadastro_sucesso.hamlet")