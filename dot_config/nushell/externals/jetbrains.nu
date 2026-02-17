def "jetbrains activate wayland" [] {
  let vmoptions = (fd -e vmoptions . ~/.config/JetBrains | lines)

  for vmoption in $vmoptions {
    let content = (open $vmoption | lines)
    let appname = (echo $vmoption | path parse | get parent | path basename)

    if ($content | find '-Dawt.toolkit.name=WLToolkit' | is-empty) {
      print $"Activating wayland for ($appname)"
      echo "\n\n-Dawt.toolkit.name=WLToolkit\n" | save --append $vmoption
    } else {
      print $"Wayland already active for ($appname)"
    }
  }
}
