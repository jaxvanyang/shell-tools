#!/usr/bin/env bash
# Daily Archive - Archive designated files & directories
# Check daily_archive.config for example configuration

set -e

script_name="$0"
config_root=/archive
archive_root=$config_root/daily
today=$(date +%y-%m-%d)
backup_file=archive-$today.tar.gz

# may be changed
config_file=$archive_root/daily_archive.config
destination=$archive_root/$backup_file
file_list=()


help_msg() {
	echo "NAME"
	echo "	$script_name - Archive designated files & directories."
	echo
	echo "SYNPOSIS"
	echo "	$script_name [-h] [config_file=...] [destination=...]"
	echo
	echo "OPTIONS"
	echo "	-h"
	echo "		Show this message."
}

# perform backup
main() {
	# parse args
	local opt
	while getopts "h" opt; do
		case "$opt" in
			h)
				help_msg
				exit
				;;
			?)
				help_msg
				exit 1
				;;
		esac
	done

	if [ $OPTIND -le $# ]; then
		shift $((OPTIND - 1))
		for opt in "$@"; do
			if [[ $opt == config_file=* || $opt == destination=* ]]; then
				eval "$opt"
			else
				echo "$script_name: bad option: $opt"
				exit 2
			fi
		done
	fi

	if [ ! -f $config_file ]; then
		echo "$script_name: config file does not exist -- $config_file"
		exit 1
	fi

	# read backup file list from config file
	exec 0<$config_file
	local file_no=1
	local file
	while read -r file; do
		if [[ -n $file && $file != \#* ]]; then
			if [ -e "$file" ]; then
				file_list+=("$file")
			else
				echo
				echo "$script_name: $config_file#$file_no: $file does not exist."
				echo
			fi
		fi

		file_no=$((file_no + 1))
	done

	if [ -z "${file_list[*]}" ]; then
		echo
		echo "No file selected, aborting..."
		echo
		exit
	fi

	# force using absolute path
	cd /

	echo
	echo "Start archive..."
	tar -czvf "$destination" "${file_list[@]}"
	echo
	echo "Archive completed"
	echo "Resulting archive file is: $destination"

	exit
}

main "$@"
