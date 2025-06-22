```bash
#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
    curl -s -u "${USERNAME}:${TOKEN}" -H "Accept: application/vnd.github.v3+json" "$url"
} # this function build fill github api url using endpoint and send get req using curl and authenticate using USERNAME and TOKEN

# Function to list users with read access
function list_users_with_read_access { 
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators" # Create endpoint get the list of collaborators from specific repo
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"  # Filter username using jq who has pull access means read access 
    
    if [[ -z "$collaborators" ]]; then  # if collaborator varible is empty then print msg "no user found " 
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:" # if found then print username of collaborators. 
        echo "$collaborators"
    fi
}

# Main execution
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
```
