#!/bin/bash

# Check if a branch name was provided as an argument
# If not provided, the script will clone the default branch
if [ -z "$1" ]; then
  echo "No branch name provided. The default branch will be used."
  BRANCH_NAME=""
else
  BRANCH_NAME="$1"
fi

# Path to the file containing the repository URL
REPO_URL_FILE="repo_url.txt"

# Check if the repository URL file exists
if [ ! -f "$REPO_URL_FILE" ]; then
  echo "Error: Repository URL file not found: $REPO_URL_FILE"
  exit 1
fi

# Read the repository URL from the file
REPO_URL=$(cat "$REPO_URL_FILE")

# Display the cloning action based on the provided branch name
if [ -z "$BRANCH_NAME" ]; then
  echo "Attempting to clone the default branch from '$REPO_URL' into 'kserve' directory..."
else
  echo "Attempting to clone the branch '$BRANCH_NAME' from '$REPO_URL' into 'kserve' directory..."
fi

# Clone the specified branch of the repository or default if not specified
if [ -z "$BRANCH_NAME" ]; then
  git clone --depth 1 "$REPO_URL" "kserve"
else
  git clone --depth 1 -b "$BRANCH_NAME" "$REPO_URL" "kserve"
fi

if [ $? -ne 0 ]; then
  echo "Error: Failed to clone repository from '$REPO_URL'"
  exit 1
else
  echo "Successfully cloned the repository."
fi

# Define the path to the file you want to check in the cloned directory
FILE_PATH="kserve/config/overlays/odh/params.env"

# Check if the specified file exists in the cloned repository
if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File not found: $FILE_PATH"
  exit 1
fi

# Additional logic to process the file or perform other actions goes here

echo "Script execution completed successfully."
