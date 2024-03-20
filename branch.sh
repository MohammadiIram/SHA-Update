#!/bin/bash

# Check if a branch name was provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <branch-name>"
  echo "Example: $0 main"
  exit 1
fi

BRANCH_NAME="$1"

# Path to the file containing the repository URL
REPO_URL_FILE="repo_url.txt"

# Check if the repository URL file exists
if [ ! -f "$REPO_URL_FILE" ]; then
  echo "Error: Repository URL file not found: $REPO_URL_FILE"
  exit 1
fi

# Read the repository URL from the file
REPO_URL=$(cat "$REPO_URL_FILE")

echo "Attempting to clone the branch '$BRANCH_NAME' from '$REPO_URL' into 'kserve' directory..."

# Clone the specified branch of the repository
git clone --depth 1 -b "$BRANCH_NAME" "$REPO_URL" "kserve"
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone branch '$BRANCH_NAME' from '$REPO_URL'"
  exit 1
else
  echo "Successfully cloned the branch '$BRANCH_NAME'."
fi

# Define the path to the file you want to check in the cloned directory
FILE_PATH="kserve/config/overlays/odh/params.env"

# Function to process the file
process_file() {
  # Your existing logic for processing the file
  echo "Processing file: $FILE_PATH"
  # Add your file processing logic here
}

# Check if the specified file exists in the cloned directory
if [ -f "$FILE_PATH" ]; then
  echo "File found: $FILE_PATH"
  process_file
else
  echo "File not found: $FILE_PATH"
fi
