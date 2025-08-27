#!/bin/bash

# Version 2.
# Generate random tuples from CSV file containing list of items.
# For example, conside CSV for triplets:
# A,B,C
# D,E,F
# G,H,I
# Random output could be
# D,B,I
# A,H,F 
# ...

set -eo pipefail
#set -x

CSV_FILE="$1"
COL_COUNT="$2"
HAS_HEADER_ROW="$3" #Set "1" to treat first row in CSV as a header row

if [[ -z "$CSV_FILE" || -z "$COL_COUNT" ]]; then
    echo "Usage: $(basename "${0}") <CSV file> <N> for generating triplets of order N."
    exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'cleanup' EXIT

cleanup(){
    rm -rf "$TMP_DIR"
}

#Clean empty lines and header row, if any, in the source CSV
if [[ "$HAS_HEADER_ROW" == "1" ]]; then
    tail -n +2 "${CSV_FILE}" > "$TMP_DIR/input.csv"
    CSV_FILE="$TMP_DIR/input.csv"
fi
sed -i '/^[[:space:]]*$/d' "$CSV_FILE"

echo "Cleaned input CSV:"
cat "$CSV_FILE"
echo "--------------------"

# Read number of columns
num_cols=$(head -n1 "$CSV_FILE" | awk -F',' '{print NF}')
if [[ "$num_cols" -ne "$COL_COUNT" ]]; then
    echo "Bad CSV- unexpected number of columns: $num_cols"
    exit 1
fi


# Extract each column, shuffle, and store temp files
for ((i=1; i<=num_cols; i++)); do
    cat "$CSV_FILE" | cut -d',' -f"$i" | shuf > "$TMP_DIR/col$i"
done

echo "Output CSV:"
paste -d',' "$TMP_DIR"/col*
