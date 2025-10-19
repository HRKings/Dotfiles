def "languagetool server start" [] {
  ^languagetool --http --config ~/.config/LanguageTool/server.properties --port 8081 --allow-origin "*"
}
