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

	GPG_EMAILS=$(gpg --list-secret-keys | rg -v "revoked" | rg ".*@.*" | sd '.*<(.*)>' '$1'  | tac)
	GIT_EMAIL=$(printf "%s\n" "${GPG_EMAILS[@]}" | fzf --preview 'gpg --keyid-format=long --locate-keys {1}')

	if [[ ! -z "$GIT_EMAIL" ]]; then
		GPG_KEY=$(gpg --keyid-format=long --locate-keys "${GIT_EMAIL}" | head -n 1 | choose -f '[/\s]' 2 )

		git config user.email "${GIT_EMAIL}" && git config user.signingkey "${GPG_KEY}"

		TITLE=$(gum style --bold --border="rounded" --foreground="32" --border-foreground="33" -- "Your current GIT credentials are:")

		NAME_TAG=$(gum style --foreground="36" -- '- Name	:  ')
		EMAIL_TAG=$(gum style --foreground="36" -- '- Email	:  ')
		GPG_TAG=$(gum style --foreground="36" -- '- GPG	:  ')

		NAME=$(gum style --italic -- "$(git config user.name)")
		EMAIL=$(gum style --italic -- "$(git config user.email)")
		GPG=$(gum style --italic -- "$(git config user.signingkey)")

		gum join --vertical \
		"$TITLE" \
		"$(gum join "$NAME_TAG" "$NAME" )" \
		"$(gum join "$EMAIL_TAG" "$EMAIL" )" \
		"$(gum join "$GPG_TAG" "$GPG" )"
	fi
}

# Dump a GitHub gist into the specified file -----------------------------------------------------------------------------------------------------------
function dumpgist {
	if [[ -z "$1" ]]; then
		echo "Please provide a file name..."
		return
	fi

	GIST=$(gh gist list -L 100 | choose 0 1 | fzf --preview 'echo {1} | choose 0 | xargs gh gist view --raw ')

	if [[ ! -z "$GIST" ]]; then
		gh gist view --raw "$(echo $GIST | choose 0)" | tail -n +3 >$1 &&
			echo "\u001b[32mCreated '\u001b[36m$1\u001b[0m' \u001b[32mwith the gist '\u001b[36m$(echo $GIST | choose 1)\u001b[32m' contents...\u001b[0m"
	fi
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

# Open yazi and cd into the directory if you quit ------------------------------------
function ya {
		tmp="$(mktemp -t "yazi-cwd.XXXXX")"
		yazi --cwd-file="$tmp"
		if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
				cd -- "$cwd"
		fi
		rm -f -- "$tmp"
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
function tere {
	local result=$(command tere "$@")
	[ -n "$result" ] && cd -- "$result"
}

# Interactive mode for cheatsheet --------------------------------------------------------------------------------
function cs {
	QUERY=$1
	if [ -z "$QUERY" ]; then
		cheat -l | awk '{print $1}' | fzf --header-lines 1 --preview-window=70% --preview 'cheat -c {1}'
	else
		cheat -l | awk '{print $1}' | fzf --header-lines 1 --preview-window=70% --preview 'cheat -c {1}' -q $QUERY
	fi
}

# Generate random hex string ------------------------------------
function sslrandhex {
	if (( $# == 0 ))
	then
		echo "generate random hex string using OpenSSL"
		echo "usage: $0 [byte quantity]"
		return 1
	fi

	openssl rand -hex $1
}

function sslrandbytes {
	if (( $# == 0 ))
	then
		echo "generate random bytes using OpenSSL"
		echo "usage: $0 [byte quantity]"
		return 1
	fi

	openssl rand $1
}

# Generate data from /dev/urandom -------------------------------
function urandomhex {
	if (( $# == 0 ))
	then
		echo "generate random hex string using /dev/urandom"
		echo "usage: $0 [byte quantity]"
		return 1
	fi

	head -c $1 /dev/urandom | hexdump -e '"%02x"'
}

function urandombytes {
	if (( $# == 0 ))
	then
		echo "generate random bytes using /dev/urandom"
		echo "usage: $0 [byte quantity]"
		return 1
	fi

	head -c $1 /dev/urandom
}

# Archive and unarchive a tarball using brotli -----------------------------------------------------------
function tarbrot {
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

function untarbrot {
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

# Check and create a blake3 hash checksum ----------------------------------------------------------------
function checkblake3 {
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

function sumblake3 {
	if (( $# == 0 ))
	then
		echo "usage: $0 [file to checksum]"
		return 1
	fi

	file_to_checksum=$1

	b3sum "$file_to_checksum" > "${file_to_checksum}.blake3"
}

# Create a .gitignore using gibo --------------------
function mkgitignore {
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
function 7zcontent {
	DIVIDER=$(printf "%$(tput cols)s" " " | tr ' ' '*')

	fd -t f -e '7z' | fzf --preview "7z l {} \
		&& printf '\n$DIVIDER\n' \
		&& 7z l {} | tail -n 1 | awk '{print \"\n Compression ratio: \" (\$4 / \$3)}' \
		&& printf '\n$DIVIDER\n' \
		&& 7z l {} | tail -n +21 | head -n -2 | awk  'BEGIN{FIELDWIDTHS=\"53 1000\"}{print \$2}' | tree --fromfile ."
}

# View 7z directory tree ----------------------------------------------------------------------------------
function 7ztree {
	if (( $# == 0 ))
	then
		echo "usage: $0 [7z archive to display]"
		return 1
	fi

	compressed_archive=$1

	7z l $compressed_archive | tail -n +21 | head -n -2 | awk  'BEGIN{FIELDWIDTHS="53 1000"}{print $2}' | tree --fromfile .
}

# A more complete implementation of convetional commits -----------------------------------------------
function cz {
	# If we are not inside a Git repo, exit
	if [[ $(git rev-parse --is-inside-work-tree 2&>/dev/null) != "true" ]]; then
		echo "Current folder '$PWD' is not a git repository."
		return 1
	fi

	# Trap any interrupts that may occur and halt the entire function
	TRAPERR() {
		if [[ $? = 130 ]]; then
			exit 130
		fi
	}

	# Hash the current path for use in the cache
	PWD_HASH=$(echo "$PWD" | sha256sum | choose 0 )

	# Define the variables that will hold the cache path
	SUMMARY_CACHE="/tmp/cz_summary-$PWD_HASH"
	DESCRIPTION_CACHE="/tmp/cz_description-$PWD_HASH"

	_commit() {
		# Preview the final changes
		gum style --bold "The commit message will be:"
		gum style --border="rounded" "$SUMMARY"
		test -n "$DESCRIPTION" && gum style --border="rounded" "$DESCRIPTION"

		# Commit these changes if user confirms
		gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION" $AMEND \
			&& rm -f $SUMMARY_CACHE && rm -f "$DESCRIPTION_CACHE"
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
	gum style --bold "Enter the commit type (defaults to 'feat'):"
	TYPE=$(printf "feat\nupdate\nbug\nfix\nsecurity\nperformance\nimprovement\ndeprecated\ni18n\na11y\nrefactor\ndocs\ntest\ndeps\nconfig\nbuild\nrelease\nwip\nstyle\nrevert\nchore" | gum filter)
	if [[ -z "$TYPE" ]]; then
		TYPE="feat"
	fi

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

	# Release the trap
	unset -f TRAPERR
}

# Transform magnet links to .torrent files ------------------------------------------------
function magnet2torrent {
	magnet_link=$1

	if [[ -z "$magnet_link" ]]; then
		echo "usage: $0 [magnet link]"
		return 1
	fi

	aria_output=$(gum spin -s meter --title 'Fetching metadata with aria2...' --show-output -- \
								aria2c --bt-stop-timeout=60 --bt-save-metadata --bt-metadata-only "$magnet_link")

	if [[ $? = 1 ]]; then
		echo "Aria error"
		return 1
	fi

	aria_error=$(echo "$aria_output" | rg "not complete")

	torrent_name=$(echo "$aria_output" | rg '\[MEMORY\]\[METADATA\]' | awk -F 'METADATA\]' '{ print $2 }'  2> /dev/null | head -n 1)

	if [[ -n "$aria_error" ]]; then
		echo "Could not download metadata for '$torrent_name'"
		return 1
	fi

	file_already_exists=$(echo "$aria_output" | rg "file already exists")
	if [[ -n "$file_already_exists" ]]; then
		echo "Torrent file already exists, trying to rename it..."
		torrent_path=$(echo "$aria_output" | rg 'Saving metadata as' | awk -F 'Saving metadata as '  '{ print $2 }' | awk -F ' failed' '{ print $1 }')
	else
		torrent_path=$(echo "$aria_output" | rg 'Saved metadata as' | awk -F 'Saved metadata as'  '{ print $2 }')
		torrent_path=${torrent_path:1:-1}
	fi

	new_torrent_file=$(echo "$(dirname "$torrent_path")/${torrent_name}.torrent" | sd "[^\S\r\n]+" "_")

	echo "Downloaded: $torrent_name"
	echo "Moving from: $torrent_path"
	echo "Moving to: $new_torrent_file"

	mv "$torrent_path" "$new_torrent_file"
}

# Move all files to their own folders ---------------------------------
function move2uniqfolder {
	fd . -t f -d 1 -x sh -c 'mkdir "{//}/{/.}" && mv "{}" "{//}/{/.}"'
}

# Create file, optionally create the parent directories ----------------
function mkfile {
	if [[ $# -eq 0 ]]; then
		echo "$0 - touch file, optionally create the parent directories"
		echo " "
		echo "Usage: $0 [options] FILE_NAME"
		echo " "
		echo "options:"
		echo "-p : create the parent directories"
		return 1
	fi

	param="$1"

	if [[ "$param" = "-p" && $# -ne 2 ]]; then
		echo "Usage: $0 -p FILE_NAME"
		return 1
	fi

	if [[ "$param" = "-p" ]]; then
		param=$2
		mkdir -p "$(dirname "$param")"
	fi

	touch "$param" && echo "$param"
}

# Open a Twitch TV stream -----------------------------
function twitch {
	# Parse the flags and parameters
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|--help)
				echo "$0 - opens a Twitch stream"
				echo " "
				echo "$0 [options]"
				echo " "
				echo "options:"
				echo "-c, --chat	Opens the chat using chatterino"
				return 0
				;;
			-c | --chat)
				CHAT="true"
				shift
				;;
			*)
				CHANNEL_NAME=$1
				shift
				;;
		esac
	done

	if [[ -n "$CHAT" ]]; then
		gum style --bold --foreground 1  "Opening the chat..."
		com.chatterino.chatterino -c "$CHANNEL_NAME" &
		CHAT_PID=$!
	fi

	streamlink "https://www.twitch.tv/$CHANNEL_NAME" best

		if [[ -n "$CHAT_PID" ]]; then
			gum style --bold --foreground 1  "Closing the chat..."
			kill -s SIGTERM $CHAT_PID
			kill -s SIGTERM "$(ps | rg 'chatterino' | choose 0)"
		fi
}

# Clear caches ------
function clearcache {
	gum confirm "Are you sure you want to clear all caches?" || return

	gum style --bold --foreground 1  "Clearing Docker..."
	docker system prune -f
	echo ""

	gum style --bold --foreground 1  "Clearing Yay..."
	yay -Sc
	echo ""

	gum style --bold --foreground 1  "Clearing dotNet..."
	dotnet nuget locals --clear all
}

# Run a command inside a docker compose container
function dockershell {
	# Parse the flags and parameters
	while [ $# -gt 0 ]; do
		case "$1" in
			-h|--help)
				echo "$0 - executes an interactive shell inside a docker"
				echo " "
				echo "$0 [options] [shell]"
				echo " "
				echo "options:"
				echo "-a, --all	'Use docker ps' instead of 'docker compose ps'"
				echo "shell:"
				echo "Especifies the shell, by default will be 'bash'"
				return 0
				;;
			-a | --all)
				CONTAINERS=
				shift
				;;
			*)
				SHELL_COMMAND=$1
				shift
				;;
		esac
	done

	if [[ -z "$CONTAINERS" ]]; then
		CONTAINERS=$(docker compose ps --status running --format '{{.Name}}')
	fi

	if [[ -z "$CONTAINERS" ]]; then
		echo "No containers were found"
		return 1
	fi

	if [[ -z "$SHELL_COMMAND" ]]; then
		SHELL_COMMAND="bash"
	fi

	SELECTED_CONTAINER=$(echo $CONTAINERS | fzf)

	if [[ -z "$SELECTED_CONTAINER" ]]; then
		echo "No container was selected"
		return 1
	fi

	docker exec -it "$SELECTED_CONTAINER" "$SHELL_COMMAND"
}
