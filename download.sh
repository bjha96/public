#! /bin/bash
# Uses youtube-dl and ffmpeg to download audio from youtube.
# AtompicParsley can be used to embed album art into the music file.
# Create  file called urls.txt in the same directory as this script
# Add list of URLs (one on each line) you want to download
# Run the script as ./download.sh

DL_URL=${1}
DEST_DIR=./Downloads

#Download cmd, modify paths here
#CMD="youtube-dl -f bestaudio[ext=m4a] --embed-thumbnail --add-metadata"
#CMD="youtube-dl -f bestaudio[ext=m4a]"
CMD="./yt-dlp -f bestaudio[ext=m4a] -o ${DEST_DIR}/%(title)s-%(id)s.%(ext)s"

if [ "a${DL_URL}" == "a"  ]; then
	DL_URL="urls.txt"
fi

if [ -f ${DL_URL} ]; then
	echo "Processing ${DL_URL}"

	URLS=$(cat ${DL_URL})
	for line in ${URLS}
	do
		${CMD} ${line}
	done
fi
