#!/bin/bash

# Check parameter
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <elf_file>" >&2
    exit 1
fi

file_name="$1"

# Check file existence
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist." >&2
    exit 1
fi

# Source messages.sh if present
if [ -f "./messages.sh" ]; then
    source ./messages.sh
fi

# Get header info
header_info=$(readelf -h "$file_name" 2>/dev/null)

if [ -z "$header_info" ]; then
    echo "Error: '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# Extract and trim fields cleanly
magic_number=$(echo "$header_info" | grep "Magic:" | sed 's/^[[:space:]]*Magic:[[:space:]]*//' | sed 's/[[:space:]]*$//')

class=$(echo "$header_info" | grep "Class:" | sed 's/^[[:space:]]*Class:[[:space:]]*//' | sed 's/[[:space:]]*$//')

byte_order=$(echo "$header_info" | grep "Data:" | sed -n 's/.*,\s*\(.*endian\).*/\1/p' | sed 's/[[:space:]]*$//')

entry_point_address=$(echo "$header_info" | grep "Entry point address:" | sed 's/^[[:space:]]*Entry point address:[[:space:]]*//' | sed 's/[[:space:]]*$//')

# Call display function from messages.sh
if declare -f display_elf_header_info > /dev/null; then
    display_elf_header_info
fi
