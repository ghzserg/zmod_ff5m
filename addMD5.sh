#!/bin/bash

# Author: Alexander

if [ $# -ne 1 ]; then echo "Usage: ./$0 your_file.gcode"; exit 1; fi
if ! [ -f $1 ]; then echo "File $1 not found"; exit 1; fi

# Calculate the MD5 hash of the file
which md5 && MD5_BIN=md5
which md5sum && MD5_BIN=md5sum
md5=$(${MD5_BIN} "$1" | awk '{print $1}')

# Define prefix
prefix="; MD5:"

# Construct the payload
payload="${prefix}${md5}"

# Create a temporary file and append the original file content
tempfile=$(mktemp)
echo "$payload" > "$tempfile"
cat "$1" >> "$tempfile"

# Move the temp file to the original file location
mv "$tempfile" "$1"
