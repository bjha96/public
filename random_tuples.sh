#!/bin/bash

# Generate random tuple (pair and triplets) from CSV file containing list of items.
# For example, conside CSV for triplets:
# A,B,C
# D,E,F
# G,H,I
# Random output could be
# D,B,I
# A,H,F 
# ...

set -eo pipefail

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $(basename ${0}) <list.csv> <2|3> for generating random pairs or triplets."
  exit 1
fi

csv_file="$1"
tupCount="$2"

if [[ ! -f "$csv_file" ]]; then
  echo "File not found!"
  exit 2
fi

#echo "Using $csv_file for $tupCount."

if [[ "$tupCount" == "2" ]]; then

   # columns into arrays  
   col1=()
   col2=()

   while IFS=',' read -r first second; do
      # Skip empty lines
      [[ -z "$first" || -z "$second" ]] && continue

      col1+=("$first")
      col2+=("$second")
   done < "$csv_file"
   
   len1=${#col1[@]}
   len2=${#col2[@]}
   
   if [[ "$len1" == "0" || "$len2" == "0" || "$len1" != "$len2" ]]; then
       echo "Bad CSV input!"
       exit 3
   fi 

   # shuffle lists
   mapfile -t s_col1 < <(shuf -e "${col1[@]}")
   mapfile -t s_col2 < <(shuf -e "${col2[@]}")
   
   for idx in "${!s_col1[@]}"; do
      printf "%d: %s - %s\n" "$idx" "${s_col1[$idx]}" "${s_col2[$idx]}"
   done

elif [[ "$tupCount" == "3" ]]; then
   col1=()
   col2=()
   col3=()

   while IFS=',' read -r first second third; do
      # Skip empty lines, if any
      [[ -z "$first" || -z "$second" || -z "$third" ]] && continue

      col1+=("$first")
      col2+=("$second")
      col3+=("$third")

   done < "$csv_file"

   len1=${#col1[@]}
   len2=${#col2[@]}
   len3=${#col3[@]}
   
   if [[ "$len1" == "0" || "$len2" == "0" || "$len3" == "0" || "$len1" != "$len2" || "$len1" != "$len3" ]]; then
       echo "Bad CSV input!"
       exit 3
   fi 
   
   mapfile -t s_col1 < <(shuf -e "${col1[@]}")
   mapfile -t s_col2 < <(shuf -e "${col2[@]}")
   mapfile -t s_col3 < <(shuf -e "${col3[@]}")
   
   for idx in "${!s_col1[@]}"; do      
      printf "%d: %s - %s - %s\n" "$idx" "${s_col1[$idx]}" "${s_col2[$idx]}" "${s_col3[$idx]}"
   done
else
   echo "Bad tuple order- ${tupCount}. Choose 2 or 3."
   exit 1
fi
