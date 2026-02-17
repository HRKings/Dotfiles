# List all installed dotNET SDKs
def "dotnet --list-sdks" [] {
  ^dotnet --list-sdks | parse '{version} [{path}]' | each { upsert channel $"($in.version | parse '{major}.{minor}.{patch}' | get major.0).0" } | each { upsert semver ($in.version | parse '{major}.{minor}.{patch}' | into record) }
}

# Update all the installed dotNET SDKs
def "dotnet-install update" [] {
  dotnet --list-sdks | each { ^$"($env.HOME)/.local/bin/dotnet-install" -InstallDir $env.DOTNET_INSTALL_DIR -c $in.channel }
}

# Delete older versions of dotNET SKDs, leaving only the most recent one per channel
def "dotnet-install clean-old" [] {
  dotnet --list-sdks | uniq-by -d channel | each { rm -rf $"($in.path)/($in.version)" }
}

def "dotnet-install mise" [] {
  dotnet --list-sdks | each {|sdk|
    let root_path = ($sdk.path | path dirname)

    mise link --force $"dotnet@($sdk.version)" $root_path
    mise link --force $"dotnet@($sdk.semver.major)" $root_path
    mise link --force $"dotnet@($sdk.channel)" $root_path
  }

  mise link --force "dotnet@latest" (dotnet --list-sdks | last | mise where $"dotnet@($in.version)")
}

def "dotnet dev-certs" [
  --clean (-c)
] {
  if ($clean) {
    ^dotnet dev-certs https --clean
    sudo rm /usr/share/ca-certificates/trust-source/anchors/aspnetcore-https-localhost.pem
  }

  let cert_path = $"($env.HOME)/.dotnet/corefx/cryptography/x509stores/my/aspnetcore-https-localhost.crt"
  ^dotnet dev-certs https -vep aspnetcore-https-localhost.crt --format PEM

  sudo cp $cert_path /usr/share/ca-certificates/trust-source/anchors/aspnetcore-https-localhost.pem

  sudo update-ca-trust

  certutil -d $"sql:($env.HOME)/.pki/nssdb" -A -t "P,," -n localhost -i $cert_path
}
