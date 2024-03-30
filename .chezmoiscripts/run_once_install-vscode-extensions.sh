#! /bin/bash

vscode_extensions=(
	# Language support ---------------------------------------------------------------
	1yib.rust-bundle                      # Rust
	a5huynh.vscode-ron                    # Rusty Object Notation
	alexcvzz.vscode-sqlite                # SQLite
	earthly.earthfile-syntax-highlighting # Earthly Build
	JuanBlanco.solidity                   # Solidity
	mikestead.dotenv                      # dotEnv
	ms-dotnettools.csharp                 # C#
	ms-python.python                      # Python
	ms-python.vscode-pylance
	nvarner.typst-lsp             # Typst
	oven.bun-vscode               # Bun runtime
	pest.pest-ide-tools           # Pest parser
	prql-lang.prql-vscode         # PRQL, next-level SQL
	redhat.ansible                # Ansible
	redhat.vscode-xml             # XML
	redhat.vscode-yaml            # YAML
	skellock.just                 # Just command runner
	svelte.svelte-vscode          # Svelte
	tamasfe.even-better-toml      # TOML
	Vue.volar                     # Vue 3 Tooling
	yzhang.markdown-all-in-one    # Markdown All-In-One
	zerotaskx.rust-extension-pack # Rust again

	# Appearance -------------------------------------------------------------
	Catppuccin.catppuccin-vsc       # Catppuccin Mocha Theme
	Catppuccin.catppuccin-vsc-icons # Catppuccin icons
	s-nlf-fh.glassit                # Transparency for VSCode

	# Utilities -----------------------------------------------------------------------------
	aaron-bond.better-comments            # Highligh todo, info and other special comments
	alefragnani.project-manager           # Project Manager
	anteprimorac.html-end-tag-labels      # Display what the end tags are (classes and such)
	antfu.iconify                         # Preview Iconify icons
	ast-grep.ast-grep-vscode              #  AST Grep support
	bbugh.change-color-format             # Change between color formats (RGB, HSL, etc.)
	bibhasdn.unique-lines                 # Delete duplicated lines
	britesnow.vscode-toggle-quotes        # Toggle quotes around strings
	deerawan.vscode-faker                 # Easily generate fake data
	eamodio.gitlens                       # Gitlens
	formulahendry.auto-close-tag          # HTML Auto-Close Tags
	formulahendry.auto-rename-tag         # HTML Auto-Rename Tags
	Gruntfuggly.todo-tree                 # Display all TODOs in the workspace
	jscearcy.rust-doc-viewer              # View locally generated Rust documentation
	ms-vsliveshare.vsliveshare            # LiveShare
	oderwat.indent-rainbow                # Colorize identation
	pnp.polacode                          # Take a screenshot of the code
	quicktype.quicktype                   # Paste JSON as types (TS, C#, etc.)
	richie5um2.vscode-sort-json           # Sort keys within JSON
	ryu1kn.partial-diff                   # Diff selections and the clipboard
	streetsidesoftware.code-spell-checker # Spell Checking
	techer.open-in-browser                # Open a file in the browser
	timonwong.shellcheck                  # Analyzer for shell scripts
	tyriar.sort-lines                     # Sort selected lines
	WallabyJs.quokka-vscode               # Inline function results for JS
	wix.vscode-import-cost                # JS Package Import Cost
	wmaurer.change-case                   # Quickly change the casing of a selection

	# Editors/Previewers ------------------------------------------------------------------------
	github.vscode-github-actions             # GitHub Actions
	hbenl.vscode-test-explorer               # Test explorer
	janisdd.vscode-edit-csv                  # CSV editor
	kisstkondoros.vscode-gutter-preview      # Preview images on hover
	mgt19937.typst-preview                   # Typst files preview
	ms-dotnettools.dotnet-interactive-vscode # DotNet support for Jupyter notebooks
	ms-toolsai.jupyter                       # Jupyter Notebooks editor
	ms-toolsai.jupyter-keymap
	ms-toolsai.jupyter-renderers
	ms-toolsai.vscode-jupyter-cell-tags
	ms-vscode-remote.remote-ssh      # Open any folder on a remote machine
	ms-vscode-remote.remote-ssh-edit # Easily edit SSH configs
	ms-vscode.remote-explorer        # View remote SSH machines
	tomoki1207.pdf                   # Preview a PDF in the editor

	# Intellisense ------------------------------------------------------------
	bradlc.vscode-tailwindcss          # TailWind tooling
	christian-kohler.npm-intellisense  # Intellisense for NPM
	christian-kohler.path-intellisense # Intellisense for File Path
	ecmel.vscode-html-css              # HTML/CSS

	# Workflow --------------------------------------------------------------------
	continue.continue                 # Add local LLM support
	fosshaas.fontsize-shortcuts       # Add fontsize shortcuts
	ms-vscode.live-server             # Live server with hot reloading
	ms-vscode.test-adapter-converter  # Test adapters
	seaql.firedbg-rust                # FireDBG, a Rust debugger with support for time-travel
	swellaby.vscode-rust-test-adapter # Rust test adapter
	usernamehw.errorlens              # Show errors and warnings inline
	vadimcn.vscode-lldb               # LLDB debugger
	vintharas.learn-vim               # For actually learning vim
	vscodevim.vim                     # Add Vim keybinds

	# Linter/Formatter ---------------------------------------------------------
	davidanson.vscode-markdownlint # Markdown Linter
	dbaeumer.vscode-eslint         # ESLint
	EditorConfig.EditorConfig      # Override workspace configs based on .editorconfig
	esbenp.prettier-vscode         # Prettier
	foxundermoon.shell-format      # Shellscript formatter
	j-brooke.fracturedjsonvsc      # A JSON formatter focusing on readability
	lkrms.inifmt                   # INI formatter
	mechatroner.rainbow-csv        # Color-code CSVs

	# Misc -----------------------------------------------------------------
	activitywatch.aw-watcher-vscode # Count time spent on coding
	adpyke.codesnap                 # Capture code in image format
	wraith13.zoombar-vscode         # Show a zoom bar in the corner of the editor
)

# Get already installed VSCode extensions ------------
installed_vscode_extensions=$(code --list-extensions)

# Install extensions ------------------------------------------------------------------------
for extension in "${vscode_extensions[@]}"; do
	# Only install if not already
	if [[ ! $installed_vscode_extensions =~ (^|[[:space:]])$extension($|[[:space:]]) ]]; then
		code --install-extension "$extension"
	fi
done
