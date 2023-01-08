#!/usr/bin/env bash

set -e

# set PREFIX if you want to modify installation location
PREFIX="${PREFIX:=$HOME/.local/bin}"

# TODO: use signal to trigger help_and_exit()
help_and_exit() {
		echo "NAME"
		echo -e "\t$0 - add an executable to your local bin path, e.g., \$home/.local/bin"
		echo
		echo "SYNOPSIS"
		echo -e "\t$0 <executable> [alias]"
		echo
		echo "DESCRIPTION"
		echo -e "\tThis command will create a wrapper script in \$PREFIX, which is \$HOME/.local/bin by default."
		echo -e "\tThe wrapper script is named as the same as the executable's basename. If the alias argument is"
		echo -e "\tprovided, it will be named as the alias argument."
		echo
		echo "EXAMPLES"
		echo -e "\t$0 hello"
		echo -e "\t\tCreate a wrapper script for hello in current directory."
		echo
		echo -e "\t$0 /path/to/hello"
		echo -e "\t\tCreate a wrapper script for hello using absolute path."
		echo
		echo -e "\t$0 hello foo"
		echo -e "\t\tCreate a wrapper script for hello, but name it as foo."
		echo
		echo -e "\tPREFIX=/path/to/install $0 hello"
		echo -e "\t\tCreate a wrapper script for hello, but in a custom directory."

		exit 1
}

main() {
	# only accept 1 or 2 command arguments
	if [[ $# -lt 1 || $# -gt 2 ]]; then
		help_and_exit
	fi

	name="$(basename "$1")"
	executable="$1"

	# Change executable to absolute path if it's relative path
	if [[ ! "$executable" =~ ^/.*$ ]]; then
		executable="$PWD/$executable"
	fi

	# Check if executable exists
	if [ ! -f "$executable" ]; then
		echo "The executable - $executable doesn't exist!" 1>&2
		exit 1
	fi

	# Use alias if provided
	if [ $# = 2 ]; then
		name="$2"
	fi

	wrapper="$PREFIX/$name"

	# Check if wrapper exists
	if [ -e "$wrapper" ]; then
		local reply="n"

		echo "The wrapper - $wrapper already exists."
		read -rp "Do you want to replace it? [y/N]: " reply
		if [[ "$reply" != [yY] ]]; then
			exit
		fi
	fi

	# Create the wrapper script
	cat > "$wrapper" <<EOF
#/usr/bin/env bash

exec "$executable" "\$@"
EOF

	# strip any "./" in executable path
	sed -i 's#\./##g' "$wrapper"

	chmod +x "$wrapper"
}

main "$@"
