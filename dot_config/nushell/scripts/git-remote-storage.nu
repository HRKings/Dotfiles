# Import utilities used in this file
source ../modules/utilities.nu

# Download all releases from GitHub compatible releases
# Compatible like: Gitea or Forjero
def "github releases download all" [
  --gitea-compat (-c): string # Enable compat for Gitea/Forjero projects by providing a base URL
  repo_path: string, # USER/REPO_NAME
] {
  let repo_releases_api = if ( not ($gitea_compat | str is-blank) ) {
      $"https://($gitea_compat)/api/v4/projects/($repo_path)/releases"
    } else {
      $"https://api.github.com/repos/($repo_path)/releases"
    }

  let releases = http-cached get $repo_releases_api
    | from json
    | select tag_name assets
    | flatten

  # TODO: pagination, omit pre-release and drafts

  for release in $releases {
    let release_path = $'./($release.tag_name)'
    let asset_path = ( [$release_path, $release.assets.name] | path join )

    if ( $asset_path | path exists ) {
      print $"Asset `($asset_path)` already downloaded"
      continue
    } else {
      print $"Downloading `($asset_path)`"
    }

    mkdir $release_path
    ^aria2c -c -x 4 --out $asset_path $release.assets.browser_download_url
  }
}

# Download all releases from GitLab compatible releases
# Compatible like: Gitea or Forjero
def "gitlab releases download all" [
  base_endpoint: string
  repo_path: string, # USER/REPO_NAME
] {
  let repo_releases_api = $"https://($base_endpoint)/api/v4/projects/($repo_path | url encode --all)/releases"

  let releases = http-cached get $repo_releases_api
    | from json
    | select tag_name assets
    | flatten

  # TODO: pagination, omit pre-release and drafts

  for release in $releases {
    let release_path = $'./($release.tag_name)'

    for asset in ($releases.links | flatten) {
      let asset_path = ( [$release_path, $asset.name] | path join )

      if ( $asset_path | path exists ) {
        print $"Asset `($asset_path)` already downloaded"
        continue
      } else {
        print $"Downloading `($asset_path)`"
      }

      mkdir $release_path
      ^aria2c -c -x 4 --out $asset_path $asset.direct_asset_url
    }
  }
}

# Download the latest release from GitHub compatible releases
# Compatible like: Gitea or Forjero
def "github releases download latest" [
  --single (-s) # Only download a single asset
  --gitea-compat (-c): string # Enable compat for Gitea/Forjero projects by providing a base URL
  repo_path: string, # USER/REPO_NAME
] {
  let repo_releases_api = if ( $gitea_compat | str is-blank ) {
      $"https://api.github.com/repos/($repo_path)/releases/latest"
    } else {
      $"https://($gitea_compat)/api/v1/repos/($repo_path)/releases/latest"
    }

  let release = http-cached get $repo_releases_api
    | from json
    | select tag_name assets
    | flatten

  let release_path = $'./($release.tag_name | first)'
  mut assets = $release.assets

  if ($single) {
    $assets = [ ($assets | sk --format={get name}) ]
  }

  for asset in $assets {
    let asset_path = ([$release_path, $asset.name] | path join)

    if ( $asset_path | path exists ) {
      print $"Asset `($asset_path)` already downloaded"
      continue
    } else {
      print $"Downloading `($asset_path)`"
    }

    mkdir $release_path
    ^aria2c -c -x 4 --out $asset_path ...$release.assets.browser_download_url
  }
}
