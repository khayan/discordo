{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Data.FileEmbed(embedFile)
import Text.Lucius
import Text.Julius
import Database.Persist.Postgresql
import Settings.StaticFiles

formUsuario :: Form Usuario
formUsuario = renderDivs $ Usuario
        <$> areq textField "Nome: " Nothing
        <*> areq passwordField "Senha: " Nothing
        
getHomeLoginR :: Handler Html
getHomeLoginR = do
    maybeNome <- lookupSession "Nome"
    nomeText <- case maybeNome of
        (Just a) -> do
            return a
        _ -> do
            return ""
    (widget,enctype) <- generateFormPost formUsuario
    defaultLayout $ do
        setTitle "Discordo! | Login"
        addStylesheet $ StaticR css_login_css
        -- ARQUIVOS EXTERNOS DE ESTILO
        --addStylesheet $ (StaticR css_materialize_css)
        --addScript $ (StaticR js_jquery_js)
        --addScript $ (StaticR js_materialize_js)
        --toWidget $(juliusFile "templates/admin.julius")
        --toWidget $(luciusFile "templates/admin.lucius")
        [whamlet|
        <div class="container">
            <div class="formulario" >    
                <a href="index.html"><h1>Discordo!</h1></a>
                    <form action=@{AuthenticationR} method=post enctype=#{enctype}>
                        <input type="text" name="username" id="username" placeholder="Username">
                        <input type="password" name="password" id="password" placeholder="Senha">
                        <input type="submit" value="Log in">
                        <p>Não está cadastrado? <a href="contato.hamlet">Crie uma conta</a></p>

        <div class="indigo z-depth-3" style="text-shadow: 1px 1px gray; padding: 10px">
        <br>
        <main>
         <div class="row">
          <div class="col s6 offset-s3 valign">
            <div class="card light-blue darken-4">
              <div class="card-content white-text">
                <span class="card-title">Login</span>
                  <form action=@{AuthenticationR} method=post enctype=#{enctype}>
                    ^{widget}
                    <button class="btn waves-effect waves-light" type="submit" name="action">Logar
        |]
        $(whamletFile "templates/footer.hamlet")

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
             redirect HomeLoginR