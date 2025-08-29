#!/bin/bash

cd ..

# Function to extract external networks from a docker-compose.yml file
extract_external_networks() {
    local compose_file="$1"

    # Use yq if available (more reliable YAML parsing)
    if command -v yq &> /dev/null; then
        yq eval '.networks | to_entries | .[] | select(.value.external == true) | .key' "$compose_file" 2>/dev/null
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
        ' "$compose_file"
    fi
}

# Arrays to store results
declare -a directories
declare -A directory_networks  # Associative array to store networks for each directory
declare -a all_networks        # Array to store all unique networks

# Main script
echo "Scanning for docker-compose.yml files and external networks..."
echo "=============================================================="

# Find all docker-compose.yml files in subdirectories and collect data
while IFS= read -r -d '' compose_file; do
    # Get the directory name
    dir_name=$(dirname "$compose_file")
    dir_name=${dir_name#./}  # Remove leading ./

    # Extract external networks
    external_networks_raw=$(extract_external_networks "$compose_file")
    
    # Convert to array and store
    directories+=("$dir_name")
    
    # Store networks for this directory
    if [ -n "$external_networks_raw" ]; then
        # Convert networks to space-separated string for storage
        directory_networks["$dir_name"]="$external_networks_raw"
        
        # Add networks to the global list (avoiding duplicates)
        while IFS= read -r network; do
            if [ -n "$network" ] && [[ ! " ${all_networks[*]} " =~ " $network " ]]; then
                all_networks+=("$network")
            fi
        done <<< "$external_networks_raw"
    else
        directory_networks["$dir_name"]=""
    fi

done < <(find . -mindepth 2 -name "docker-compose.yml" -type f -print0 | sort -z)

# Check if no files were found
if [ ${#directories[@]} -eq 0 ]; then
    echo "No docker-compose.yml files found in subdirectories."
    exit 0
fi

# Sort networks alphabetically
IFS=$'\n' all_networks=($(sort <<<"${all_networks[*]}"))
unset IFS

# Calculate column widths
max_dir_length=0
for dir in "${directories[@]}"; do
    if [ ${#dir} -gt $max_dir_length ]; then
        max_dir_length=${#dir}
    fi
done
max_dir_length=$((max_dir_length + 2))

# Calculate network column widths (minimum width is the network name length + 2)
declare -a network_widths
for network in "${all_networks[@]}"; do
    width=$((${#network} + 2))
    network_widths+=($width)
done

# Print header
printf "%-${max_dir_length}s" "Directory"
for i in "${!all_networks[@]}"; do
    printf "%-${network_widths[$i]}s" "${all_networks[$i]}"
done
echo

# Print separator line
printf "%*s" $max_dir_length "" | tr ' ' '-'
for width in "${network_widths[@]}"; do
    printf "%*s" $width "" | tr ' ' '-'
done
echo

# Print data rows
for dir in "${directories[@]}"; do
    printf "%-${max_dir_length}s" "$dir"
    
    # Get networks for this directory
    dir_networks="${directory_networks[$dir]}"
    
    # For each possible network, check if this directory has it
    for i in "${!all_networks[@]}"; do
        network="${all_networks[$i]}"
        if [[ "$dir_networks" == *"$network"* ]]; then
            printf "%-${network_widths[$i]}s" "$network"
        else
            printf "%-${network_widths[$i]}s" ""
        fi
    done
    echo
done
