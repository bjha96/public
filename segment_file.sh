#!/bin/bash

#********************************************************************************
# Extract strings and print head, mid and tail segments from a file.
# The number of bytes to print from head/mid/tail is taken as input.
# Author: B Jha
#********************************************************************************

set -aeo pipefail
#set -x

#bytes
DEFAULT_SEGMENT_SIZE=8192

TMPROOT="$(mktemp -dq)"
trap 'rm -rf "$TMPROOT"' EXIT


printable_strings() {
    local input="$1"
    strings -ae S -n 3 "$input" | tr -dc '[:print:]\n'
}

create_tempfile(){
    local tmpf="$(mktemp -p "$TMPROOT")"
    echo "$tmpf"
}


read_bytes()
{
    local input="$1" #file
    local start_offset="$2" #bytes
    local count="$3" #bytes
    local tmp="$(create_tempfile)"
    dd if="$input" of="$tmp" bs=1 skip=$start_offset count=$count 2>/dev/null
    printable_strings "$tmp"
    rm -f "$tmp" 
}


segment_file(){

    local input="$1" # file path
    local first="${2:-$DEFAULT_SEGMENT_SIZE}" # bytes
    local mid="${3:-$DEFAULT_SEGMENT_SIZE}"
    local last="${4:-$DEFAULT_SEGMENT_SIZE}"

    local limit=$((first + mid + last))
    local filesz="$(stat -c %s "$input")"

    if [[ "$filesz" -gt "$limit" ]]; then
        #read head + mid + tail segments
        local tmpf="$(create_tempfile)"
        #head
        read_bytes "$input" 0 $first > "$tmpf"
        echo "..." >> "$tmpf"
        echo "..." >> "$tmpf"
        
        #mid part
        local mid_offset=$((filesz - mid/2))
        read_bytes "$input" $mid_offset  $mid >> "$tmpf"
        echo "..." >> "$tmpf"
        echo "..." >> "$tmpf"
        
        #tail
        local tail_offset=$((filesz - last))
        read_bytes "$input" $tail_offset  $last  >> "$tmpf"
        
        cat "$tmpf"
        rm -f "$tmpf"                
    else
        printable_strings "$input"
    fi    
}

#main
if [[ -f "$1" ]]; then
    segment_file "$@"
else
    echo "$(basename "$0") <file> [<head>] [<mid>] [<tail>]"
    exit 1
fi
