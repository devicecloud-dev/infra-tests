#!/bin/bash

# Define the source file and directory
SOURCE_FILE="flows/onboard-chrome/onboard-chrome-1.yaml"
DIR="flows/onboard-chrome"

# Make sure the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: Source file $SOURCE_FILE does not exist"
  exit 1
fi

# Copy the file for versions 2 through 10
for i in {2..10}; do
  TARGET_FILE="$DIR/onboard-chrome-$i.yaml"
  cp "$SOURCE_FILE" "$TARGET_FILE"
  echo "Created $TARGET_FILE"
done

echo "Successfully created all flow files" 