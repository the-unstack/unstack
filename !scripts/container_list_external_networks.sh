#!/bin/bash

cd ..

# Function to extract external networks from a docker-compose.yml file
extract_external_networks() {
    local compose_file="$1"
    
    # Use yq if available (more reliable YAML parsing)
    if command -v yq &> /dev/null; then
        yq eval '.networks | to_entries | .[] | select(.value.external == true) | .key' "$compose_file" 2>/dev/null | tr '\n' ' '
    else
        # Fallback to grep/awk parsing (less reliable but works without yq)
        awk '
        /^networks:/ { in_networks = 1; next }
        /^[a-zA-Z]/ && !/^  / { in_networks = 0 }
        in_networks && /^  [a-zA-Z_-]+:/ { 
            network_name = $1
            gsub(/:/, "", network_name)
            getline
            if ($0 ~ /external: *true/) {
                print network_name
            }
        }
        ' "$compose_file" | tr '\n' ' '
    fi
}

# Arrays to store results
declare -a directories
declare -a networks_list

# Main script
echo "Scanning for docker-compose.yml files and external networks..."
echo "=============================================================="

# Find all docker-compose.yml files in subdirectories and collect data
while IFS= read -r -d '' compose_file; do
    # Get the directory name
    dir_name=$(dirname "$compose_file")
    dir_name=${dir_name#./}  # Remove leading ./
    
    # Extract external networks
    external_networks=$(extract_external_networks "$compose_file")
    
    # Store in arrays
    directories+=("$dir_name")
    if [ -n "$external_networks" ]; then
        networks_list+=("${external_networks% }")  # Remove trailing space
    else
        networks_list+=("(no external networks)")
    fi
    
done < <(find . -mindepth 2 -name "docker-compose.yml" -type f -print0 | sort -z)

# Find the maximum length of directory names for alignment
max_length=0
for dir in "${directories[@]}"; do
    if [ ${#dir} -gt $max_length ]; then
        max_length=${#dir}
    fi
done

# Add some padding
max_length=$((max_length + 4))

# Print aligned results
for i in "${!directories[@]}"; do
    printf "%-${max_length}s %s\n" "${directories[$i]}" "${networks_list[$i]}"
done

# Check if no files were found
if [ ${#directories[@]} -eq 0 ]; then
    echo "No docker-compose.yml files found in subdirectories."
fi