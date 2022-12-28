#!/bin/bash

MY_BIN=${MY_BIN:-~/.local/bin}
prefix_path=''

if [[ 1 -le $# && $# -le 2 && ! $1 =~ ^/.*$ ]]; then
	prefix_path=$PWD
fi

if [ $# = 1 ]; then
	ln -s "$prefix_path/$1" "$MY_BIN"
elif [ $# = 2 ]; then
	ln -s "$prefix_path/$1" "$MY_BIN/$2"
else
	echo 'Usage: add_my_bin <executable> [alias]'
fi
