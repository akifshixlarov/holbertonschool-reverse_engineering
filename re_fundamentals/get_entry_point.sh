#!/bin/bash
# Check if a file argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <elf_file>" >&2
    exit 1
fi

file_name="$1"

# Check if the file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist." >&2
    exit 1
fi

# Source messages.sh if present in the current directory
if [ -f "./messages.sh" ]; then
    source ./messages.sh
fi

# Retrieve raw header data using readelf
header_info=$(readelf -h "$file_name" 2>/dev/null)

# Verify if readelf output is valid ELF header information
if [ -z "$header_info" ]; then
    echo "Error: '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# Extract individual fields
magic_number=$(echo "$header_info" | grep "Magic:" | sed 's/^[[:space:]]*Magic:[[:space:]]*//')
class=$(echo "$header_info" | grep "Class:" | awk -F':' '{print $2}' | xargs)
byte_order=$(echo "$header_info" | grep "Data:" | awk -F':' '{print $2}' | xargs)
entry_point_address=$(echo "$header_info" | grep "Entry point address:" | awk -F':' '{print $2}' | xargs)

# If display_elf_header_info exists from messages.sh, call it; otherwise fallback format
if declare -f display_elf_header_info > /dev/null; then
    display_elf_header_info
else
    echo "Header Information for '$file_name':"
    echo "--------------------------------"
    echo "Magic Number: $magic_number"
    echo "Class: $class"
    echo "Byte Order: $byte_order"
    echo "Entry Point Address: $entry_point_address"
fi
