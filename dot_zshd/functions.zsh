#================================================================================================================================
# Functions
#================================================================================================================================

# Reload all ZSH configs ----------------------------------
function reloadzsh {
	for file in $(fd -e "zsh" . "$HOME/.zshd"); do
		echo "\u001b[32m> Reloading \u001b[36m$file\u001b[0m"
		source $file
	done
}

# Select which Git email and GPG signing key to use inside a repository -----------------------------------------------
function gitcfg {
	if [[ $(git rev-parse --is-inside-work-tree 2&>/dev/null) != "true" ]]; then
		echo "Current folder '$PWD' is not a git repository."
		return 1
	fi

	GPG_EMAILS=$(gpg --list-secret-keys | grep ".*\@.*" | cut -d '<' -f 2 | cut -d '>' -f 1 | tac)
	GIT_EMAIL=$(printf "%s\n" "${GPG_EMAILS[@]}" | fzf --preview 'gpg --keyid-format=long --locate-keys {1}')

	if [[ ! -z "$GIT_EMAIL" ]]; then
		GPG_KEY=$(gpg --keyid-format=long --locate-keys "${GIT_EMAIL}" | head -n 1 | cut -d '/' -f 2 | cut -d ' ' -f 1)

		git config user.email "${GIT_EMAIL}" && git config user.signingkey "${GPG_KEY}"

		echo "\u001b[32mYour current GIT credentials are:\u001b[0m"
		echo "\u001b[36m - Name  :\u001b[0m $(git config user.name)"
		echo "\u001b[36m - Email :\u001b[0m $(git config user.email)"
		echo "\u001b[36m - GPG   :\u001b[0m $(git config user.signingkey)"
	fi
}

# Dump a GitHub gist into the specified file -----------------------------------------------------------------------------------------------------------
function dumpgist {
	if [[ -z "$1" ]]; then
		echo "Please provide a file name..."
		return
	fi

	GIST=$(gh gist list -L 100 | grep "Template Docker Compose File" | cut -f 1,2 | fzf --preview 'echo {1} | cut -f 1 | xargs gh gist view --raw ')

	if [[ ! -z "$GIST" ]]; then
		gh gist view --raw "$(echo $GIST | cut -f 1)" | tail -n +3 >$1 &&
			echo "\u001b[32mCreated '\u001b[36m$1\u001b[0m' \u001b[32mwith the gist '\u001b[36m$(echo $GIST | cut -f 2)\u001b[32m' contents...\u001b[0m"
	fi
}

# List all packages in both Upstream and AUR, with fuzzy searching via fzf ----------------------------------------------------
function pkgfind {
	query=$@

	if [ -z "$query" ]; then
		echo "Usage: pkgfind PKG_NAME"
		echo "PKG_NAME: the name of the package to search"
		return
	fi

	yay -Sl | awk '{print "["$1"] " $2($4=="" ? "" : " *") }' | fzf --multi --bind 'tab:preview:yay -Si {2}' -q "$query" | cut -d " " -f 2 | xargs -ro yay -S
}

# Execute a Git command in all repositories contained in nested directories ----
function gitrecurse {
	DIVIDER=$(printf "%$(tput cols)s" " " | tr ' ' '-')
	fd -HI '^.git$' -x sh -c "echo $DIVIDER && cd '{//}' && printf '\u001b[32m> $PWD\u001b[0m\n' && git $@"
}

# Executes a diff in two strings ----------------------------------------
function stringdiff {
	echo $1 >/tmp/string_diff_file_1
	echo $2 >/tmp/string_diff_file_2
	delta /tmp/string_diff_file_1 /tmp/string_diff_file_2
}

# Open ranger and cd into the directory if you quit with Q ------------------------------------
function ranger {
	local IFS=$'\t\n'
	local tempfile="$(mktemp -t tmp.XXXXXX)"
	local ranger_cmd=(
		command
		ranger
		--cmd="map Q chain shell echo %d > "$tempfile"; quitall"
	)

	${ranger_cmd[@]} "$@"
	if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]]; then
		cd -- "$(cat "$tempfile")" || return
	fi
	command rm -f -- "$tempfile" 2>/dev/null
}

# Benchmark the RAM usage of a given command -----------------------------------------------------------
function benchmem {
	runs=$1
	command_name=$2
	values_output_file=$3

	if [ -z "$runs" ] || [ -z "$command_name" ]; then
		echo "Usage: benchmem RUNS COMMAND_NAME <VALUES_OUTPUT_FILE>"
		echo "RUNS: the number of time to run the benchmark"
		echo "COMMAND_NAME: the command to benchmark"
		echo "VALUES_OUTPUT_FILE: Optional. A file to output the memory values of each benchmark"
		return
	fi

	total=0

	min=16000000000
	max=0

	values=()
	for _ in {1..$runs}; do
		i=$( (command time -f "%M" "$command_name") 2>&1 >/dev/null)
		total=$(echo $total+$i | bc)

		if (($i < $min)); then
			min=$i
		fi

		if (($i > $max)); then
			max=$i
		fi

		values+=($i)
	done
	mean=$(echo "scale=2; $total / $runs" | bc)

	standardDeviation=0
	for value in "${values[@]}"; do
		standardDeviation=$(echo "$standardDeviation + ( ( $value - $mean )^2 )" | bc)
	done
	standardDeviation=$(echo "scale=2; sqrt( $standardDeviation / $runs )" | bc)

	if [ ! -z "$values_output_file" ]; then
		echo "${values[@]}" >$values_output_file
	fi

	echo "$command_name | $mean ± $standardDeviation | $min | $max" | column -t -s '|' -N 'Command,Mean,Min,Max'
	echo "Obs.: the mean is followed by '± Standard Deviation'"
}

# Calculate the ratio of the mean of various numeric outputs in relation to another --------------------------------------
function relativecalc {
	size=$1
	base_path=$2

	if [ -z "$size" ] || [ -z "$base_path" ] || [ -z "$3" ]; then
		echo "Usage: relativecalc SIZE VALUES_FILE_BASE VALUES_FILE_1 <VALUES_FILE_2> .. <VALUES_FILE_N>"
		echo "SIZE: The amount of lines of the files"
		echo "VALUES_FILE_BASE: A file containing SIZE lines with one value per line, serving as a comparison base"
		echo "VALUES_FILE_1: A file containing SIZE lines with one value per line to compare against the base"
		echo "VALUES_FILE_2 .. N: Optional. More files to compare against the base"
	fi

	files=($@)
	base_file=($(cat $base_path))

	output=$(printf "$base_path | 1.0\n")

	for file_path in "${files[@]:2}"; do
		current_file=($(cat $file_path))
		total=0
		values=()

		for line in {1..$size}; do
			relative=$(echo "scale=2; ${current_file[$line]} / ${base_file["line"]}" | bc)
			total=$(echo $total+$relative | bc)
			values+=($relative)
		done
		mean=$(echo "scale=2; $total / $size" | bc)

		standardDeviation=0
		for value in "${values[@]}"; do
			standardDeviation=$(echo "$standardDeviation + ( ( $value - $mean )^2 )" | bc)
		done
		standardDeviation=$(echo "scale=2; sqrt( $standardDeviation / $size )" | bc)

		output=$(printf "$output\n$file_path | $mean ± $standardDeviation\n")
	done

	echo "$output" | column -t -s '|' -N 'File,Relative'
	echo "Obs.: the mean is followed by '± Standard Deviation'"
}

# Navigate folder with ease --------------
tere() {
	local result=$(command tere "$@")
	[ -n "$result" ] && cd -- "$result"
}

# Interactive mode for cheatsheet --------------------------------------------------------------------------------
cs() {
	QUERY=$1
	if [ -z "$QUERY" ]; then
		cheat -l | awk '{print $1}' | fzf --header-lines 1 --preview-window=70% --preview 'cheat -c {1}'
	else
		cheat -l | awk '{print $1}' | fzf --header-lines 1 --preview-window=70% --preview 'cheat -c {1}' -q $QUERY
	fi
}

# Generate random hex string ------
randhex() {
	openssl rand -hex $1 | toupper
}

# Archive and unarchive a tarball using brotli -----------------------------------------------------------
tarbrot() {
	if [ ! command -v brotli &> /dev/null ]; then
		echo "'brotli' could not be found"
		return 1
	fi

	local archive_name path_to_archive
	if (( $# < 2 ))
	then
		echo "usage: $0 [archive_name.tar.br] [/path/to/include/into/archive ...]"
		return 1
	fi

	archive_name="${1:t}"
	path_to_archive="${@:2}"

	tar -cvf "${archive_name}" --use-compress-program="$(where brotli)" "${=path_to_archive}"
}

untarbrot() {
	if [ ! command -v brotli &> /dev/null ]; then
		echo "'brotli' could not be found"
		return 1
	fi

	local archive_name
	if (( $# == 0 ))
	then
		echo "usage: $0 [archive_name.tar.br]"
		return 1
	fi

	archive_name="${1:t}"

	tar -xvf "$archive_name" --use-compress-program="$(where brotli)"
}

# Check a blake3 hash checksum ----------------------------------------------------------------
checkblake3() {
	if (( $# == 0 ))
	then
		echo "usage: $0 [file to check] <blake3 file>"
		echo "if the blake3 file is not specified, the file 'file_to_check.blake3' will be used"
		return 1
	fi

	file_to_check=$1
	blake3_file=$2

	if [[ -z $blake3_file ]]; then
		blake3_file="${file_to_check}.blake3"
	fi

	echo "$(cat "$blake3_file" | awk '{print $1}')  $file_to_check" | b3sum -c
}

# Create a blake3 hash checksum -------------------------------
sumblake3() {
	if (( $# == 0 ))
	then
		echo "usage: $0 [file to checksum]"
		return 1
	fi

	file_to_checksum=$1

	b3sum "$file_to_checksum" > "${file_to_checksum}.blake3"
}

# Create a .gitignore using gibo --------------------
mkgitignore() {
	if [ ! command -v gibo &> /dev/null ]; then
		echo "gibo cannot be found"
		return 1
	fi

	template=$1

	if [ -z $template ]; then
		echo "usage: $0 [template]"
		echo "to get the template list, use: gibo list"
		return 1
	fi

	gibo dump "$template" > .gitignore
}

# View 7z files ---------------------------------------------------------------------------------------------------
7zcontent() {
	DIVIDER=$(printf "%$(tput cols)s" " " | tr ' ' '*')

	fd -t f -e '7z' | fzf --preview "7z l {} \
	&& printf '\n$DIVIDER\n' \
	&& 7z l {} | tail -n 1 | awk '{print \"\n Compression ratio: \" (\$4 / \$3)}' \
	&& printf '\n$DIVIDER\n' \
	&& 7z l {} | tail -n +21 | head -n -2 | awk  'BEGIN{FIELDWIDTHS=\"53 1000\"}{print \$2}' | tree --fromfile ."
}

# View 7z directory tree ----------------------------------------------------------------------------------
7ztree() {
	if (( $# == 0 ))
	then
		echo "usage: $0 [7z archive to display]"
		return 1
	fi

	compressed_archive=$1

	7z l $compressed_archive | tail -n +21 | head -n -2 | awk  'BEGIN{FIELDWIDTHS="53 1000"}{print $2}' | tree --fromfile .
}

# Open nnn with cd on quit and the preview plugin --------------------------------------
n ()
{
		# Block nesting of nnn in subshells
		if [[ "${NNNLVL:-0}" -ge 1 ]]; then
				echo "nnn is already running"
				return
		fi

		# The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
		# If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
		# see. To cd on quit only on ^G, remove the "export" and make sure not to
		# use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
		#     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
		export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

		# Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
		# stty start undef
		# stty stop undef
		# stty lwrap undef
		# stty lnext undef

		export PAGER="less -R"
		# a = file preview requirement; r = Use advcpmv
		export NNN_OPTS="ar"
		export NNN_PLUG='v:preview-tui'

		# The backslash allows one to alias n to nnn if desired without making an
		# infinitely recursive alias
		\nnn -P v "$@"

		if [ -f "$NNN_TMPFILE" ]; then
						. "$NNN_TMPFILE"
						rm -f "$NNN_TMPFILE" > /dev/null
		fi
}

# A more complete implementation of convetional commits -----------------------------------------------
cz() (
	# If we are not inside a Git repo, exit
	if [[ $(git rev-parse --is-inside-work-tree 2&>/dev/null) != "true" ]]; then
		echo "Current folder '$PWD' is not a git repository."
		return 1
	fi

	# Define the variables that will hold the cache path
	SUMMARY_CACHE="/tmp/cz_summary"
	DESCRIPTION_CACHE="/tmp/cz_description"

	_commit() {
		# Preview the final changes
		gum style --bold "The commit message will be:"
		gum style --border="rounded" "$SUMMARY"
		test -n "$DESCRIPTION" && gum style --border="rounded" "$DESCRIPTION"

		# Commit these changes if user confirms
		gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION" $AMEND
	}

	# Parse the flags and parameters
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|--help)
				echo "$0 - commit with a conventional commit format"
				echo " "
				echo "$0 [options]"
				echo " "
				echo "options:"
				echo "-h, --help                        Show this help message"
				echo "-s, --scope SCOPE                 Specify the commit scope"
				echo "-m, --message MESSAGE             Specify the commit message"
				echo "-d, --description DESCRIPTION     Specify the commit body"
				echo "-q, --quick                       Skip all prompts"
				echo "--retry                           Retry the last commit"
				echo "--amend                           Build the message and amend the previous commit"
				return 0
				;;
			-s* | --scope*)
				if test $# -gt 1; then
					shift
					SCOPE=$1
				fi

				if [[ "$1" == *"="* ]]; then
					SCOPE=$(echo $1 | sd '^[^=]*=' '')
				fi

				if [[ -z "$SCOPE" ]]; then
					gum style --bold --foreground 1 "No scope was specified"
					return 1
				fi
				shift
				;;
			-m* | --message*)
				if test $# -gt 1; then
					shift
					MESSAGE=$1
				fi

				if [[ "$1" == *"="* ]]; then
					MESSAGE=$(echo $1 | sd '^[^=]*=' '')
				fi

				if [[ -z "$MESSAGE" ]]; then
					gum style --bold --foreground 1 "No message was specified"
					return 1
				fi
				shift
				;;
			-d* | --description*)
				if test $# -gt 1; then
					shift
					DESCRIPTION=$1
				fi

				if [[ "$1" == *"="* ]]; then
					DESCRIPTION=$(echo $1 | sd '^[^=]*=' '')
				fi

				if [[ -z "$DESCRIPTION" ]]; then
					gum style --bold --foreground 1 "No description was specified"
					return 1
				fi
				shift
				;;
			--amend)
				AMEND="--amend"
				shift
				;;
			--retry)
				RETRY="true"
				shift
				;;
			-q | --quick)
				QUICK="true"
				shift
				;;
			*)
				gum style --bold --foreground 1  "Unknown option '$1'"
				return 1
				;;
		esac
	done

	# If the user wants to retry
	if [[ "$RETRY" = "true" ]]; then
		# If we don't have a cache, alert the user and exit
		if [ ! -f "$SUMMARY_CACHE" ]; then
			printf "There's nothing to retry"
			return 1
		fi

		# Load the cache
		SUMMARY=$(cat $SUMMARY_CACHE)
		DESCRIPTION=$(cat $DESCRIPTION_CACHE)

		# Execute the commit sequence
		_commit

		# Exit with the last status code
		return $?
	fi

	# Ask for the commit type
	gum style --bold "Enter the commit type:"
	TYPE=$(printf "feat\nfix\ndocs\nstyle\nrefactor\ntest\nchore\nrevert" | gum filter)

	# Get the scope from the params, if not, ask it
	if [[ -z "$SCOPE" && "$QUICK" != "true" ]]; then
		gum style --bold "Enter the commit scope:"
		SCOPE=$(gum input --placeholder "scope")
	fi

	# Since the scope is optional, wrap it in parentheses if it has a value.
	test -n "$SCOPE" && SCOPE="($SCOPE)"

	# Ask for breaking changes
	gum confirm --default=false "There are breaking changes?" && BREAKING="!"

	# Ask for a breaking change footer if not in the quick mode
	if [[ -n "$BREAKING" && "$QUICK" != "true" ]]; then
		gum style --bold "Enter the breaking change description:"
		BREAKING_FOOTER=$(gum input --placeholder "Breaking change footer")
	fi

	# Build the summary
	SUMMARY="${TYPE}${SCOPE}${BREAKING}: "

	# If the message is set, create the commit summary
	# if not pre-populate the input with the type(scope): so that the user may change it
	if [ -z "$MESSAGE" ]; then
		gum style --bold "Enter the commit summary:"

		# Don't let the message be empty
		while [ -z "$MESSAGE" ]; do
			MESSAGE=$(gum input --prompt "> $SUMMARY" --placeholder "Summary of this change")

			# If the input is interrupted, then exit
			INPUT_EXIT_CODE="$?"
			if [ "$INPUT_EXIT_CODE" -eq 130 -o "$INPUT_EXIT_CODE" -eq 2 -o "$INPUT_EXIT_CODE" -eq 1 ]; then
				return 1
			fi

		done
	fi

	# Update the summary
	SUMMARY="${SUMMARY}${MESSAGE}"

	# If the description is empty and not in the quick mode, ask for a description
	if [[ -z "$DESCRIPTION" && "$QUICK" != "true" ]]; then
		gum style --bold "Enter the commit description:"
		DESCRIPTION=$(gum write --placeholder "Details of this change")
	fi

	# Append the breaking change footer to the description
	test -n $BREAKING_FOOTER && DESCRIPTION=$(printf "$DESCRIPTION\n$BREAKING_FOOTER")

	# Save the summary and description to the temp files
	echo "$SUMMARY" > $SUMMARY_CACHE
	echo "$DESCRIPTION" > $DESCRIPTION_CACHE

	# Execute the commit sequence
	_commit
)

# Transform magnet links to .torrent files ------------------------------------------------
magnet2torrent() {
	magnet_link=$1

	aria_output_path="/tmp/magnet2link_aria"

  if [[ -z "$magnet_link" ]]; then
    echo "usage: $0 [magnet link]"
    return 1
  fi

  gum spin -s meter --title 'Fetching metadata with aria2...' -- \
		sh -c "aria2c --bt-stop-timeout=60 --bt-save-metadata --bt-metadata-only \"$magnet_link\" > $aria_output_path"

	aria_output=$(cat "$aria_output_path")

  if [[ "$?" -eq 1 ]]; then
    echo "Aria error"
    return 1
  fi

  aria_error=$(echo "$aria_output" | grep "not complete")

  torrent_name=$(echo "$aria_output" | grep '\[MEMORY\]\[METADATA\]' | awk -F 'METADATA\]' '{ print $2 }'  2> /dev/null | head -n 1)

  if [[ -n "$aria_error" ]]; then
    echo "Could not download metadata for '$torrent_name'"
    return 1
  fi

	file_already_exists=$(echo "$aria_output" | grep "file already exists")
	if [[ -n "$file_already_exists" ]]; then
		echo "Torrent file already exists, trying to rename it..."
		torrent_path=$(echo "$aria_output" | grep 'Saving metadata as' | awk -F 'Saving metadata as '  '{ print $2 }' | awk -F ' failed' '{ print $1 }')
	else
		torrent_path=$(echo "$aria_output" | grep 'Saved metadata as' | awk -F 'Saved metadata as'  '{ print $2 }')
  	torrent_path=${torrent_path:1:-1}
	fi

  new_torrent_file=$(echo "$(dirname "$torrent_path")/${torrent_name}.torrent"| sd "[^\S\r\n]+" "_")

  echo "Downloaded: $torrent_name"
  echo "Moving from: $torrent_path"
  echo "Moving to: $new_torrent_file"

  mv "$torrent_path" "$new_torrent_file"
}
