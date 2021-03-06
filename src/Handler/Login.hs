{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Lucius
import Text.Julius

getHomeLoginR :: Handler Html
getHomeLoginR = do
    maybeNome <- lookupSession "Nome"
    nomeText <- case maybeNome of
        (Just a) -> do
            return a
        _ -> do
            return ""
    defaultLayout $ do
        setTitle "Discordo! | Login"
        toWidgetHead [hamlet|
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
        |]
        toWidget $(luciusFile "templates/login.lucius")
        [whamlet|
        <div class="container">
            <div class="formulario" >    
                <a href=@{LandingR}><h1>Discordo!</h1></a>
                    <form action=@{AuthenticationR} method=post>
                        <input type="text" name="f1" id="username" placeholder="Username">
                        <input type="password" name="f2" id="password" placeholder="Senha">
                        <input type="submit" name="action" value="Login">
                        <p>Não está cadastrado? <a href=@{CadastrarR}>Crie uma conta</a></p>
        |]
postAuthenticationR :: Handler Html
postAuthenticationR = do
                 login <- runInputPost $ ireq textField "f1"
                 pass <- runInputPost $ ireq textField "f2"
                 maybeAdmin <- runDB $ getBy $ UniqueLogin login pass
                 case maybeAdmin of
                             Just _ -> do
                                        setSession "Nome" $ login
                                        redirect HomeR
                             _ -> do
                                    redirect HomeLoginR
getExitLogoutR :: Handler Html
getExitLogoutR = do
             deleteSession "Nome"
             redirect LandingR