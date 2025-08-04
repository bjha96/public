#!/bin/bash

#Recursively scan the given folder, file or an archive, and dump printable strings
#in the files found in them. The archives are expanded and recursively scanned. 

# Known archive types
ARCHIVE_EXTENSIONS=("zip" "jar" "tar" "tar.gz" "tgz" "gz" "bz2" "xz")

#convert to lowercase for comparison of file names
shopt -s nocaseglob nocasematch

# Check if directory is given
if [ -z "$1" ]; then
	echo "Usage: $(basename $0) /path/to/folder/or/file/to/process"
  exit 1
fi

START_DIR="$1"
EC=2

if [[ -d "$START_DIR" || -f "$START_DIR" ]]; then
  echo "Scanning: '$START_DIR'"
  EC=0
fi

if [[ "$EC" != "0" ]]; then
  echo "'$START_DIR' does not exist or not a file or folder'"
  exit $EC
fi


# Create a temp directory for extracted archives
# and cleanup after exit.
TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

# Extract an archive
extract_archive() {
  local file="$1"
  local dest="$2"
  case "$file" in
    *.zip) unzip -qq "$file" -d "$dest" ;;
    *.jar) unzip -qq "$file" -d "$dest" ;;
    *.tar.gz|*.tgz) tar -xzf "$file" -C "$dest" ;;
    *.tar.bz2) tar -xjf "$file" -C "$dest" ;;
    *.tar.xz) tar -xJf "$file" -C "$dest" ;;
    *.tar) tar -xf "$file" -C "$dest" ;;
    *.gz) gunzip -c "$file" > "$dest/$(basename "${file%.gz}")" ;;
    *.bz2) bunzip2 -c "$file" > "$dest/$(basename "${file%.bz2}")" ;;
    *.xz) unxz -c "$file" > "$dest/$(basename "${file%.xz}")" ;;
    *) return 1 ;;
  esac
}

# Process a (file or) directory recursively
# Handle duplicate files in the archive by 
# appending a random number into the temp 
# folder name.
process_path() {
  local path="$1"
  if [[ -f "$path" ]]; then
    for ext in "${ARCHIVE_EXTENSIONS[@]}"; do
      if [[ "$path" == *.$ext ]]; then
        local extract_dir="$TMPROOT/$(basename "$path")_extract_${RANDOM}"
        mkdir -p "$extract_dir"
        echo "*** Extracting archive: $path **************************"
        extract_archive "$path" "$extract_dir"
        process_path "$extract_dir"
        return
      fi
    done
    # If not an archive, dump strings from the file as is
    echo "---- Strings from: $path ----*************************************"
    strings "$path"
    echo
  elif [[ -d "$path" ]]; then
    # Recurse into sub-directory
    find "$path" -mindepth 1 -print0 | while IFS= read -r -d '' entry; do
      process_path "$entry"
    done
  fi
}

# Process input directory
process_path "$START_DIR"

