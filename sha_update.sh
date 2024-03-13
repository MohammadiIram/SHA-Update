#!/bin/bash

# Specify the repository URL
REPO_URL="https://github.com/red-hat-data-services/kserve.git"
# Specify the branch to checkout, for example, 'master'
BRANCH_NAME="rhoai-2.8"
# Specify the file name you're looking for
FILE_PATH="kserve/config/overlays/odh/params.env"

echo "$FILE_PATH"
# Clone the repository
# git clone -b $BRANCH_NAME $REPO_URL kserve
# git clone --depth 1 -b "$BRANCH_NAME" "https://github.com/red-hat-data-services/kserve.git" "kserve"


# Change directory to the cloned repository
# cd kserve

# Find the file within the repository. Adjust the path as needed.
# This example uses 'find' to search the whole repository for the file.
# If you know the exact directory, you can directly use 'cat' to print its content.
if [ -f "$FILE_PATH" ]; then
    echo "Found file: $FILE_PATH"
    echo "Contents of $FILE_PATH:"
    cat "$FILE_PATH"
else
    echo "File not found: $FILE_PATH"
fi

# Optionally, cleanup by removing the cloned repository if no longer needed
# cd ..
# rm -rf kserve_repo


