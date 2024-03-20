#!/bin/bash

# Assuming 'repo_url.txt' contains the Git repository URL on its first line
REPO_URL_FILE="repo_url.txt"
if [ ! -f "$REPO_URL_FILE" ]; then
  echo "Error: Repository URL file not found: $REPO_URL_FILE"
  exit 1
fi
REPO_URL=$(head -n 1 "$REPO_URL_FILE")


function clone_repo() {
  local BRANCH_NAME=$1
  git clone --depth 1 -b "$BRANCH_NAME" "$REPO_URL" "kserve"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to access $REPO_URL"
    return 1
  fi
}

FILE_PATH="kserve/config/overlays/odh/params.env"

# function get_latest_rhods_version() {
#   local rhods_version
#   rhods_version=$(git ls-remote --heads $REPO_URL | grep 'rhoai' | awk -F'/' '{print $NF}' | sort -V | tail -1)
#   echo "$rhods_version"
# }

extract_names_with_sbom_extension() {
 local tag="$1"
 local hash="$2"

    json_response=$(curl -s https://quay.io/api/v1/repository/modh/$tag/tag/ | jq -r '.tags | .[:3] | map(select(.name | endswith(".sbom"))) | .[].name')

    local names_part=$(echo "$json_response" | sed 's/^sha256-\(.*\)\.sbom$/\1/')
    echo "$names_part"

    if [ "$hash" = "$names_part" ]; then
        echo "$tag"
        echo -e "\e[32m$hash\e[0m matches \e[32m$names_part\e[0m"
    else
        echo "$tag"
        echo -e "\e[31m$hash\e[0m does not match \e[31m$names_part\e[0m"
        exit 1 # Exit with non-zero status code on mismatch
    fi
}

main() {
    clone_repo $BRANCH_NAME

    if [ -f "$FILE_PATH" ]; then
        echo "File found: $FILE_PATH"
        local input=$(<"$FILE_PATH")

        while IFS= read -r line; do
            local name=$(echo "$line" | cut -d'=' -f1)
            local hash=$(echo "$line" | awk -F 'sha256:' '{print $2}')

            extract_names_with_sbom_extension $name $hash
        done <<< "$input"
        rm -rf kserve
    else
        echo "File not found: $FILE_PATH"
    fi
}

main
