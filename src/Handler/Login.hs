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
        <$> areq textField "Email: " Nothing
        <*> areq passwordField "Senha: " Nothing
        
getHomeLoginR :: Handler Html
getHomeLoginR = do
    maybeEmail <- lookupSession "email"
    emailText <- case maybeEmail of
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
        --$(whamletFile "templates/header.hamlet")
        [whamlet|
        <div class="indigo z-depth-3" style="text-shadow: 1px 1px gray; padding: 10px">
          <div class="col s12">
             <a href="@{HomeR}" class="breadcrumb"><u>Home</u>
             <a class="breadcrumb"><u>Login</u>
        <br>
        <main>
         <div class="row">
          <div class="col s6 offset-s3 valign">
            <div class="card light-blue darken-4">
              <div class="card-content white-text">
                <span class="card-title">Login de Admin</span>
                  <form action=@{AuthR} method=post enctype=#{enctype}>
                    ^{widget}
                    <button class="btn waves-effect waves-light" type="submit" name="action">Logar
                      <i class="material-icons right">send</i>
        |]
        $(whamletFile "templates/footer.hamlet")
