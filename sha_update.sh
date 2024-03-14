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
   # cat "$FILE_PATH"
else
    echo "File not found: $FILE_PATH"
fi

# Optionally, cleanup by removing the cloned repository if no longer needed
# cd ..
# rm -rf kserve_repo



extract_names_with_sbom_extension() {
 local tag="$1"
 local hash="$2"

    json_response=$(curl -s https://quay.io/api/v1/repository/modh/$tag/tag/ | jq -r '.tags | .[:3] | map(select(.name | endswith(".sbom"))) | .[].name')

   # echo "$json_response"

    local names_part=$(echo "$json_response" | sed 's/^sha256-\(.*\)\.sbom$/\1/')
    echo "$names_part"


    if [ "$hash" = "$names_part" ]; then
        # Print in green if equal
        echo -e "\e[32m$hash\e[0m matches \e[32m$names_part\e[0m"
    else
        # Print in red if not equal
        echo -e "\e[31m$hash\e[0m does not match \e[31m$names_part\e[0m"
    fi

}

main(){

    # call function for clone
    # read from file and store the contetnt in input varial

    local input='kserve-controller=quay.io/modh/kserve-controller@sha256:af19ec0f06a579f4f7778fef8bbf9c559c1814953593b1e64704b262c09d614a
kserve-agent=quay.io/modh/kserve-agent@sha256:fa885ed04ea836d9ec2ae038a5d6721010566a2df6df3c615e4f3cefb14794d9
kserve-router=quay.io/modh/kserve-router@sha256:3ce38cc18a92f35da98d371248a2d9d01b1d8f10ec94a6b94f8ec1922d436028'

  #  local input="$1"

    # Extract names before '=' using cut
    local names=$(echo "$input" | cut -d'=' -f1)

    #echo "$names"

     # for name in $names; do
     #   echo "$name"
        # Perform your operation here
    #    extract_names_with_sbom_extension $name
     # done


 # Loop through each line of input
    while IFS= read -r line; do
        # Extract the name before '='
        local name=$(echo "$line" | cut -d'=' -f1)

        # Extract the text after 'sha256:'
        local hash=$(echo "$line" | awk -F 'sha256:' '{print $2}')

        extract_names_with_sbom_extension $name $hash

       # echo "Name: $name"
       # echo "Hash: $hash"
    done <<< "$input"



}

main