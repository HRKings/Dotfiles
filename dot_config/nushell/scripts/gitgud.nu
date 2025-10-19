# Import utilities used in this file
source ../modules/utilities.nu

const commit_types = [
  { name: "feature", shorthand: "feat", docs: "Add a new feature", gitmoji: "✨" }
  { name: "update", shorthand: null, docs: "Adjust or remove a already existing feature", gitmoji: "⬆️" }
  { name: "fix", shorthand: null, docs: "Represents a bug fix", gitmoji: "🩹" }
  { name: "hotfix", shorthand: null, docs: "Represents a urgent fix", gitmoji: "🚑️" }
  { name: "security", shorthand: "sec", docs: "Security related adjustment", gitmoji: "🔒️" }
  { name: "performance", shorthand: "perf", docs: "A code change that improves performance", gitmoji: "⚡️" }
  { name: "improvement", shorthand: "improv", docs: "Adjustments that improve existing features", gitmoji: "✏️" }
  { name: "deprecated", shorthand: "deprec", docs: "Deprecates an existing feature", gitmoji: "🗑️" }
  { name: "i18n", shorthand: null, docs: "Changes that relates to i18n (internationalization) (e.g. new translations)", gitmoji: "🌐" }
  { name: "a11y", shorthand: null, docs: "Changes that relates to a11y (accessibility)", gitmoji: "♿️" }
  { name: "refactor", shorthand: "refac", docs: "A code change that do not change the already existing logic (e.g. formatting)", gitmoji: "♻️" }
  { name: "documentation", shorthand: "docs", docs: "Documentation only changes (e.g. README)", gitmoji: "📝" }
  { name: "test", shorthand: null, docs: "Adding, removing or modifying tests", gitmoji: "🧪" }
  { name: "dependencies", shorthand: "deps", docs: "Adding, removing or updating dependencies", gitmoji: "📦️" }
  { name: "tooling", shorthand: "tool", docs: "Addition, removal, updating or configuration changes of tooling", gitmoji: "🔧" }
  { name: "build", shorthand: null, docs: "Changes that affect the build system or external dependencies", gitmoji: "🏗️" }
  { name: "release", shorthand: null, docs: "Any changes relating to releases (e.g. version bumps)", gitmoji: "🚀" }
  { name: "wip", shorthand: null, docs: "Represents a work in progress change", gitmoji: "🚧" }
  { name: "style", shorthand: null, docs: "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)", gitmoji: "🎨" }
  { name: "revert", shorthand: null, docs: "Any reverts, be from merges, rebases or regressions", gitmoji: "⏪️" }
  { name: "ci/ci", shorthand: null, docs: "Changes to CI/CD configuration files and scripts", gitmoji: "👷" }
  { name: "misc", shorthand: null, docs: "Other changes that do not modify src or test files", gitmoji: "👽️" }
  { name: "initial", shorthand: "init", docs: "First commit of a new project!", gitmoji: "🎉" }
]

def "gitgud generate" [
  description: string
  --type (-t): string
  --scope (-s): string
  --body (-b): list<string>
  --footer (-f): list<string>
  --breaking (-!)
  --breaking-message: string
] {
  mut type = $type
  if ($type | is-empty) {
    let selected_type = ( $commit_types | sk --format={
        let t = $in
        [ $t.name $t.docs $t.shorthand ]
          | where not ($it | default '' | str trim | is-empty )
          | str join (' ' | repeat (tput cols | into int) | str join)
      } --pre-select={ $in.name == 'feature' } --preview={ get -o docs } --preview-window="wrap"
    )

    let shorthand = $selected_type | get -o shorthand
    let type_name = $selected_type | get -o name
    $type = $shorthand | default $type_name | default 'feat'
  }

  let $breaking = if ($breaking) { "!" } else { "" }

  mut scope = $scope
  if ($scope | is-not-empty) {
    $scope = $"\(($scope)\)"
  }

  mut breaking_message = $breaking_message
  if ($breaking_message | is-not-empty) {
    $breaking_message = $"BREAKING CHANGE: ($scope)"
  }

  let message = $"($type)($scope)($breaking): ($description)"

  let body = $body | default [] | str join "\n\n"
  let footer = $footer | default [] | str join "\n"

  let message = [ $message $body $footer $breaking_message ] | str join "\n\n"

  return ($message | str trim)
}

def "gitgud" [
  description: string
  --type (-t): string
  --scope (-s): string
  --body (-b): list<string>
  --footer (-f): list<string>
  --breaking (-!)
  --breaking-message: string
  --amend
] {
  let cache_path = $"/tmp/gitgud_cache_(pwd | hash blake3)"

  let message = ( gitgud generate $description
      --type=$type
      --scope=$scope
      --body=$body
      --footer=$footer
      --breaking=$breaking
      --breaking-message=$breaking_message )

  $message | save -f $cache_path

  mut git_command_params = [ "-m" $message ]
  if ($amend) {
    $git_command_params = $git_command_params | append [ "--no-edit" "--amend" ]
  }

  try {
    gum style --bold "The commit message will be:"
		gum style --border="rounded" $message

    ^gum confirm "Commit changes?"
    ^git commit ...$git_command_params
    rm $cache_path
  }
}
alias ggc = gitgud

def "gitgud retry" [
  --amend
] {
  let cache_path = $"/tmp/gitgud_cache_(pwd | hash blake3)"

  if (not ($cache_path | path exists)) {
    print "No saved commit message found!"
    return
  }

  let message = (^cat $cache_path)

  mut git_command_params = [ "-m" $message ]
  if ($amend) {
    $git_command_params = $git_command_params | append [ "--no-edit" "--amend" ]
  }

  try {
    gum style --bold "The commit message will be:"
		gum style --border="rounded" $message

    ^gum confirm "Commit changes?"
    ^git commit ...$git_command_params
    rm $cache_path
  }
}
alias ggr = gitgud retry
