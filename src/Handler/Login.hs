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
        setTitle "Login"
        -- ARQUIVOS EXTERNOS DE ESTILO
        --addStylesheet $ (StaticR css_materialize_css)
        --addScript $ (StaticR js_jquery_js)
        --addScript $ (StaticR js_materialize_js)
        --toWidget $(juliusFile "templates/admin.julius")
        --toWidget $(luciusFile "templates/admin.lucius")
        [whamlet|
        <div class="indigo z-depth-3" style="text-shadow: 1px 1px gray; padding: 10px">
        <br>
        <main>
         <div class="row">
          <div class="col s6 offset-s3 valign">
            <div class="card light-blue darken-4">
              <div class="card-content white-text">
                <span class="card-title">Login de Admin</span>
                  <form action=@{AuthenticationR} method=post enctype=#{enctype}>
                    ^{widget}
                    <button class="btn waves-effect waves-light" type="submit" name="action">Logar
                      <i class="material-icons right">send</i>
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

