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
                    
    publicacoes <- runDB $ selectList [] [Desc PublicacoesId]
				
    defaultLayout $ do 
        setTitle "Discordo!"
        addStylesheetRemote "https://fonts.googleapis.com/css?family=Anton&display=swap"
        addScriptRemote "https://code.jquery.com/jquery-1.12.0.min.js"
        addStylesheet $ StaticR css_reset_css
        addStylesheet $ StaticR css_estilo_css
        toWidget $(juliusFile "templates/navbar.julius")

        [whamlet|
            <nav>
                <ul class="menu">
                    <li class="logo"><a href="@{HomeR}">Discordo!
                    <li class="item"><a href="@{ExitLogoutR}">Sair
                    <li class="toggle"><span class="bars">
        
            <header>
                <form method="post" action="@{PublicacoesR}">
                    <Legend>Plante a discórdia!
                    <textarea name="discordia" id="discordia" cols="70" rows="5" maxlength="150" placeholder="Máx 250 caracteres">
                    <input type="submit" value="Enviar">

            <main id="principal">
                <div class="timeline">
                $forall (Entity id publi concordo discordo) <- pulicacoes
                    <div class="pergunta-timeline">
                        <p>Você concorda...
                        <p class="pergunta">#{publi}
                        <div>
                            <button class="agree">Concordo!
                            <span>#{concordo}
                            <button class="disagree">Discordo!
                            <span>#{discordo}
                            
            <footer>
                <p>
                    <strong>Desenvolvido por:<br> 
                    Gustavo de Carvalho Rodrigues, <br>
                    Janaina Dias, <br>
                    Khayan Malantrucco
                <p>&copy;Discordo 2019
        |]