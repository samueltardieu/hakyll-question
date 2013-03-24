--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Applicative ((<|>))
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "*.md" $ do
    route $ setExtension "html"
    compile $ do
      img <- getResourceString >>= twitterImage
      pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html"
            (constField "twitterImage" img `mappend` defaultContext)

  match "templates/*.html" $ compile templateCompiler

--------------------------------------------------------------------------------
twitterImage :: Item String -> Compiler String
twitterImage item = fmap itemBody $
  loadAndApplyTemplate "templates/twitter-card-image.html" defaultContext item
  <|> makeItem ""
