# List all installed dotNET SDKs
def "dotnet --list-sdks" [] {
  ^dotnet --list-sdks | parse '{version} [{path}]' | each { upsert channel $"($in.version | str substring ..0).0" }
}

# Update all the installed dotNET SDKs
def "dotnet-install update" [] {
  dotnet --list-sdks | each { ^sudo $"($env.HOME)/.local/bin/dotnet-install" -InstallDir $env.DOTNET_INSTALL_DIR -c $in.channel }
}

# Delete older versions of dotNET SKDs, leaving only the most recent one per channel
def "dotnet-install clean-old" [] {
  dotnet --list-sdks | uniq-by -d channel | each { ^sudo rm -rf $"($in.path)/($in.version)" }
}
