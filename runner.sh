#!/bin/bash

# Just like Code Runner
# Reference: https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash

# Support language:
# 1. C
# 2. C++
# 3. Java
# 4. Kotlin
# 5. Python

to_red() {
	echo -en '\033[0;31m'
}

to_green() {
	echo -en '\033[0;32m'
}

reset_color() {
	echo -en '\033[0m'
}

help_msg() {
	echo -e 'Please name a file\n\nUsage: runner.sh <source_file>'
}


if [ $# -lt 1 ]; then
	to_red
	help_msg
	exit 3
fi

if [ ! -e "$1" ]; then
	to_red
	echo 'Error: file not exists!'
	exit 2
fi

# run_out($1=out_file, $2=lang)
run_out() {
	local cmd=""
	if [[ $2 =~ ^c$|^cpp$ ]]; then
		cmd="$1"
	elif [ "$2" = 'java' ]; then
		cmd="java ${1%.*}"
	elif [ "$2" = 'kt' ]; then
		cmd="java -jar $1";
	elif [ "$2" = 'py' ]; then
		cmd="python $1";
	else
		to_red
		echo 'Error: Unknown file type!'
		exit 1
	fi

	if ! eval "$cmd"; then
		to_red
		echo 'Error: Execution failed!'
		exit 2
	fi
}

# run($1=out_file, $2=lang)
run() {
	to_green
	echo 'Log: Start running'
	reset_color

	start_time=$(date +%s%N)

	if [ -e input.txt ]; then
		run_out "$1" "$1" < input.txt
	else
		run_out "$1" "$2"
	fi

	end_time=$(date +%s%N)

	to_green
	echo -e "Log: Execution time: $(( (end_time - start_time) / 1000000))ms"
}

# examples are after statements
# the default type is C++ source file
path=$1;					# test.cc
file_name=${path%.*};	# test
extension=${path##*.};	# cc
out_file=$file_name.out;	# test.out

# use normal extension as language type
lang='cpp';

if [[ $extension == c ]]; then
	lang='c'
	out_file=$file_name.exe	# be different to C++ out file
elif [ "$extension" = 'java' ]; then
	lang='java'
	out_file=$file_name.class
elif [ "$extension" = 'kt' ]; then
	lang='kt'
	out_file=$file_name.jar
elif [ "$extension" = 'py' ]; then
	lang='py'
	out_file=$path	# Python has no out file
elif [[ ! $extension =~ ^cc$|^cpp$|^cx$ ]]; then
	to_red
	echo 'Error: Unknow file type!'
	exit 1
fi

if [[ $lang =~ ^c$|^cpp$ && ! $out_file =~ ^/.*$ ]]; then
	out_file=./$out_file
fi

if [ -e "$out_file" ]; then
	source_time=$(stat -c %Y "$path");
	out_time=$(stat -c %Y "$out_file");

	if [ "$source_time" -lt "$out_time" ]; then
		to_green
		echo -e "Log: Reuse compiled file"

		run $out_file $lang
		exit 0
	fi
fi

# compile($1=path, $2=out_file, $3=lang)
compile() {
	path=$1
	out_file=$2
	lang=$3

	if [ "$lang" = 'py' ]; then
		return 0
	fi

	to_green
	echo 'Log: Start compiling'

	start_time=$(date +%s%N)

	local cmd=""
	if [ "$lang" = 'cpp' ]; then
		cmd="g++ $path -Wall -O2 -o $out_file"
	elif [ "$lang" = 'c' ]; then
		cmd="gcc $path -Wall -O2 -o $out_file"
	elif [ "$lang" = 'java' ]; then
		cmd="javac $path"
	elif [ "$lang" = 'kt' ]; then
		cmd="kotlinc $path -include-runtime -d $out_file"
	fi

	if ! eval "$cmd"; then
		return 3
	fi

	end_time=$(date +%s%N)

	to_green
	echo "Log: Compilation time: $(( (end_time - start_time) / 1000000 ))ms"
}

compile "$path" "$out_file" "$lang" && run "$out_file" "$lang"
