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
        addScriptRemote "https://code.jquery.com/jquery-1.12.0.min.js"
        toWidgetHead $(luciusFile "templates/home.lucius")
        toWidgetHead [hamlet|
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        |]

        toWidget $(juliusFile "templates/navbar.julius")
        toWidget $(juliusFile "templates/contador.julius")

        [whamlet|
            <nav>
                <ul class="menu">
                    <li class="logo"><a href="@{HomeR}">Discordo!</a>
                    <li>Olá, #{login}! Seja bem vindo!
                    <li class="item"><a href="@{ExitLogoutR}">Sair</a>
                    <li class="toggle"><span class="bars">
        
            <header>
                <form method="post" action="@{PublicacoesR}">
                    <legend>Plante a discórdia!
                    <textarea name="discordia" id="discordia" cols="70" rows="5" maxlength="150" placeholder="Máx 250 caracteres">
                    <input type="submit" value="Enviar">

            <main id="principal">
                <div class="timeline">
                    $forall (Entity id publi) <- publicacoes
                        <div class="pergunta-timeline">
                            <p class="pergunta">#{publicacoesPubli publi}
                            <div>
                                <button class="agree" onClick(contador("concordo"))>Concordo!
                                <button class="disagree" onClick(contador("discordo"))>Discordo!
                            <div class="contador">
                                <p>&#128077; <script>getConcordo()
                                <p>&#128078; <script>getDiscordo()
                            
            <footer>
                <p>
                    <strong>Desenvolvido por:<br> 
                    Gustavo de Carvalho Rodrigues, <br>
                    Janaina Dias, <br>
                    Khayan Malantrucco
                <p>&copy;Discordo 2019
        |]