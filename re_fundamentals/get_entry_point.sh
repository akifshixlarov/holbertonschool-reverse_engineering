#!/bin/bash

# Parameter validation
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <elf_file>" >&2
    exit 1
fi

file_name="$1"

# Check if file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist." >&2
    exit 1
fi

# Source messages.sh if present
if [ -f "./messages.sh" ]; then
    source ./messages.sh
fi

# Retrieve header info
header_info=$(readelf -h "$file_name" 2>/dev/null)

if [ -z "$header_info" ]; then
    echo "Error: '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# Extract individual fields clean of apostrophe syntax issues
magic_number=$(echo "$header_info" | grep "Magic:" | sed -n 's/^[[:space:]]*Magic:[[:space:]]*//p')

class=$(echo "$header_info" | grep "Class:" | sed -n 's/^[[:space:]]*Class:[[:space:]]*//p')

# Extract "little endian" or "big endian" correctly from the "Data:" line
byte_order=$(echo "$header_info" | grep "Data:" | sed -n 's/.*,\s*\(.*endian\).*/\1/p')

entry_point_address=$(echo "$header_info" | grep "Entry point address:" | sed -n 's/^[[:space:]]*Entry point address:[[:space:]]*//p')

# Call function from messages.sh
if declare -f display_elf_header_info > /dev/null; then
    display_elf_header_info
fi
