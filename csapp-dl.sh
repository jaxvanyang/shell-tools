#!/bin/bash

function help() {
  echo "Description: use Wget to download CSAPP code"
  echo "Usage: $0 [code_replative_path [...]]"
  echo "Example: $0 intro/hello.c"
  echo "More info: http://csapp.cs.cmu.edu/3e/code.html"
}

if [[ $# = 0 ]]; then
  help
  exit 0
fi

for code in "$@"; do
  if ! wget "http://csapp.cs.cmu.edu/3e/ics3/code/$code"; then
    help
    exit 1
  fi
done
