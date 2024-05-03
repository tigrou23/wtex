#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: $0 <tex file to watch>"
  echo "$0 -h for help"
  exit 1
fi

if [ "$1" == "-h" ]
then
  echo "Usage: $0 <tex file to watch>"
  echo "This script will watch the specified tex file for changes and recompile it"
  echo "The compilation output will be redirected in /tmp/wtex.log and only shown if there are errors"
  echo "At the moment, only pdflatex is supported, configuration will be added in a future release"
  exit 0
fi

if [ ! -f "$1" ]
then
  echo "File $1 not found"
  exit 1
fi

# Check is inotifywait is installed
if [ ! -x "$(command -v inotifywait)" ]
then
  echo "inotifywait is not installed. Please install it before running this script"
  exit 1
fi

echo "Watching $1 for changes..."

while true
do
  inotifywait -qq -e modify "$1"

  echo "Compiling $1..."
  pdflatex -interaction=nonstopmode "$1" > /tmp/wtex.log

  if [ $? -ne 0 ]
  then
    cat /tmp/wtex.log
  fi

  echo "Done."
done

