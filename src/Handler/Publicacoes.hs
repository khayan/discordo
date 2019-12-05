{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Publicacoes where

import Import
import Data.FileEmbed(embedFile)
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql
import Settings.StaticFiles

postPublicacoesR :: Handler Html
postPublicacoesR = do
    publi <- runInputPost $ ireq textField "publi"
    --concordo <- 0
    --discordo <- 0
    publiId <- runDB $ insert $ Publicacoes publi 0 0
    redirect HomeR