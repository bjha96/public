#!/bin/bash

#set -x

#print date
echo "***************STARTING**************"

date

DEST_HOST=192.168.0.5
DEST_SHARE=NetBackup

SRC_DIR="${HOME}/"
RSYNC_USER=${USER}

#Embed the current hostane and username in the destination folder
DEST_LOC="${DEST_HOST}::${DEST_SHARE}/$(hostname)-$(uname)/${USER}"

#Default rsync options
RSYNC_OPTS="-azrmuPhF --delete --delete-excluded -e ssh"

#Check debug is enabled, set verbose flag
if [ "a1" == "a$1" ]; then
    RSYNC_OPTS="-v ${RSYNC_OPTS}"
fi


#Prepare a list of files to be included, by extension
RSYNC_INC_LIST="${SRC_DIR}/rsync.include"

if [[ ! -e ${RSYNC_INC_LIST} ]]; then
    
    mkdir -p $(dirname "${RSYNC_INC_LIST}")
    touch "${RSYNC_INC_LIST}"
    
    echo "#List of files to be included in rsync" > "${RSYNC_INC_LIST}"
    echo "*/" >> "${RSYNC_INC_LIST}"
    echo "*.*" >> "${RSYNC_INC_LIST}"
fi

RSYNC_OPTS="${RSYNC_OPTS} --include-from=${RSYNC_INC_LIST} --exclude=*"

#Src: https://gist.github.com/StefanHamminga/2b1734240025f5ee916a
RSYNC_SKIP_COMPRESS="3g2/3gp/3gpp/7z/aac/ace/amr/apk/appx/appxbundle/arc/arj/asf/avi/bz2/cab/crypt5/crypt7/crypt8/deb/dmg/drc/ear/gz/flac/flv/gpg/iso/jar/jp2/jpg/jpeg/lz/lzma/lzo/m4a/m4p/m4v/mkv/msi/mov/mp3/mp4/mpeg/mpg/mpv/oga/ogg/ogv/opus/pack/png/qt/rar/rpm/rzip/s7z/sfx/svgz/tbz/tgz/tlz/txz/vob/wim/wma/wmv/xz/z/zip/zst"


rsync ${RSYNC_OPTS} --skip-compress="${RSYNC_SKIP_COMPRESS}" "${SRC_DIR}" ${RSYNC_USER}@${DEST_LOC}

