def "notification history" [] {
  ^busctl -j --user call org.freedesktop.Notifications /fr/emersion/Mako fr.emersion.Mako ListHistory | from json
}
