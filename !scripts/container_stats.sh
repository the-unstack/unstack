#!/bin/bash

# Parse command line arguments
REFRESH=true
HIGHLIGHT_COLUMN=2

while [[ $# -gt 0 ]]; do
    case $1 in
        -r)
            REFRESH=false
            shift
            ;;
        [1-3])
            HIGHLIGHT_COLUMN=$1
            shift
            ;;
        *)
            echo "Usage: $0 [-r] [1|2|3]"
            echo "  -r: Refresh data from docker stats"
            echo "  1: Highlight NAME column"
            echo "  2: Highlight CPU% column (default)"
            echo "  3: Highlight MEM USAGE column"
            exit 1
            ;;
    esac
done

# Color definitions
RED='\x1b[31m'
RESET='\x1b[0m'

# Create a temporary file
#TMPFILE=$(mktemp)
TMPFILE="docker-stats.tmp"

# Run docker stats and store output in temp file (only if -r flag is used)
if [ "$REFRESH" = true ]; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" |  cut -d'/' -f1 > "$TMPFILE"
fi

# Display the contents of the temp file with color highlighting
case $HIGHLIGHT_COLUMN in
    1)
        # Highlight NAME column
        cat "$TMPFILE" | awk 'NR==1{print; next} {print | "sort -k 1"}' | sed "
        1s/NAME/${RED}NAME${RESET}/
        2,\$s/^\([^[:space:]]*\)/${RED}\1${RESET}/"
        ;;
    2)
        # Highlight CPU % column
        cat "$TMPFILE" | awk 'NR==1{print; next} {print | "sort -k 2 -h -r"}' | sed "
        1s/CPU %/${RED}CPU %${RESET}/
        2s/.*/${RED}&${RESET}/
        3,\$s/\([0-9.]*%\)/${RED}\1${RESET}/g
        "
        ;;
    3)
        # Highlight MEM USAGE column
        cat "$TMPFILE" | awk 'NR==1{print; next} {print | "sort -k 3 -h -r"}' | sed "
        1s/MEM USAGE/${RED}MEM USAGE${RESET}/
        2s/.*/${RED}&${RESET}/
        3,\$s/\([0-9.]*[KMGT]\?i\?B\)/${RED}\1${RESET}/g
        "
        ;;
esac

# Add separator line
echo "-----------------------------------------------------"

# Calculate and display totals
awk '
BEGIN { FS="[ \t]+"; total_cpu = 0; total_mem_bytes = 0 }
NR > 1 {
    # Extract CPU percentage (remove % and convert to float)
    if (match($2, /([0-9.]+)%/, cpu_match)) {
        total_cpu += cpu_match[1]
    }
    
    # Extract memory usage and convert to bytes  
    if (match($3, /([0-9.]+)([KMGT]?i?B)/, mem_match)) {
        value = mem_match[1]
        unit = mem_match[2]
        if (unit == "B") mem_bytes = value
        else if (unit == "KiB") mem_bytes = value * 1024
        else if (unit == "MiB") mem_bytes = value * 1024 * 1024
        else if (unit == "GiB") mem_bytes = value * 1024 * 1024 * 1024
        else if (unit == "TiB") mem_bytes = value * 1024 * 1024 * 1024 * 1024
        else mem_bytes = value * 1024 * 1024  # Default to MiB if no unit
        total_mem_bytes += mem_bytes
    }
}
END {
    # Convert total memory back to appropriate unit
    if (total_mem_bytes >= 1024*1024*1024*1024) {
        mem_display = sprintf("%.1fTiB", total_mem_bytes/(1024*1024*1024*1024))
    } else if (total_mem_bytes >= 1024*1024*1024) {
        mem_display = sprintf("%.1fGiB", total_mem_bytes/(1024*1024*1024))
    } else if (total_mem_bytes >= 1024*1024) {
        mem_display = sprintf("%.1fMiB", total_mem_bytes/(1024*1024))
    } else if (total_mem_bytes >= 1024) {
        mem_display = sprintf("%.1fKiB", total_mem_bytes/1024)
    } else {
        mem_display = sprintf("%.0fB", total_mem_bytes)
    }
    
    printf "Total                          %6.2f%%     %8s\n", total_cpu, mem_display
}' "$TMPFILE"

# Count lines displayed (data + separator + totals + interactive prompt)
lines_displayed=$(($(wc -l < "$TMPFILE") + 4))  # +3 for separator, totals, and prompt line

# Interactive menu
echo -n "Select 1,2,3 for sorting, r to refresh, q to exit:"
read -n 1 user_input
echo  # Add newline after input

case $user_input in
    1|2|3)
        # Move cursor back up and clear lines, then reset cursor
        echo -e "\033[${lines_displayed}A"
        for ((i=2; i<=lines_displayed; i++)); do echo -e "\033[K"; done
        echo -e "\033[${lines_displayed}A"
        exec "$0" $user_input -r
        ;;
    r|R)
        # Move cursor back up and clear lines, then reset cursor
        echo -e "\033[${lines_displayed}A"
        for ((i=2; i<=lines_displayed; i++)); do echo -e "\033[K"; done
        echo -e "\033[${lines_displayed}A"
        exec "$0" $HIGHLIGHT_COLUMN
        ;;
    q|Q)
        echo "Exiting..."
        ;;
    *)
        echo "Invalid selection. Exiting..."
        ;;
esac

# Clean up the temporary file
rm "$TMPFILE"