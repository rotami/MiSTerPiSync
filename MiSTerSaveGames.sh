#!/bin/bash

# Replace these with your own FTP details
FTP_USER="your_ftp_username"
FTP_PASS="your_ftp_password"
MISTER_1_IP="your_mister_1_ip"
MISTER_2_IP="your_mister_2_ip"

# FTP directory details
SAVEGAMES_DIR="/media/fat/saves"
SAVESTATES_DIR="/media/fat/savestates"

# Replace these with your own local savegames directories
LOCAL_SAVEGAMES_DIR_1="your_local_savegames_dir_1"
LOCAL_SAVEGAMES_DIR_2="your_local_savegames_dir_2"

# Replace these with your own local savestates directories
LOCAL_SAVESTATES_DIR_1="your_local_savestates_dir_1"
LOCAL_SAVESTATES_DIR_2="your_local_savestates_dir_2"

# Function to download files if Mister is active
download_files() {
    local MISTER_IP=$1
    local LOCAL_SAVEGAMES_DIR=$2
    local LOCAL_SAVESTATES_DIR=$3

    # Check if Mister is active
    if ping -c 1 $MISTER_IP &> /dev/null
    then
        # Download savegames from Mister
        lftp -f "
        open $MISTER_IP
        user $FTP_USER $FTP_PASS
        lcd $LOCAL_SAVEGAMES_DIR
        mirror --delete $SAVEGAMES_DIR
        bye
        "

        # Download savestates from Mister
        lftp -f "
        open $MISTER_IP
        user $FTP_USER $FTP_PASS
        lcd $LOCAL_SAVESTATES_DIR
        mirror --delete $SAVESTATES_DIR
        bye
        "
    else
        echo "Mister at $MISTER_IP is not active. Skipping download."
    fi
}

# Function to upload files if Mister is active
upload_files() {
    local MISTER_IP=$1
    local LOCAL_SAVEGAMES_DIR=$2
    local LOCAL_SAVESTATES_DIR=$3

    # Check if Mister is active
    if ping -c 1 $MISTER_IP &> /dev/null
    then
        # Upload savegames to Mister
        lftp -f "
        open $MISTER_IP
        user $FTP_USER $FTP_PASS
        lcd $LOCAL_SAVEGAMES_DIR
        mirror -R --delete $SAVEGAMES_DIR
        bye
        "

        # Upload savestates to Mister
        lftp -f "
        open $MISTER_IP
        user $FTP_USER $FTP_PASS
        lcd $LOCAL_SAVESTATES_DIR
        mirror -R --delete $SAVESTATES_DIR
        bye
        "
    else
        echo "Mister at $MISTER_IP is not active. Skipping upload."
    fi
}

# Download files from both Misters
download_files $MISTER_1_IP $LOCAL_SAVEGAMES_DIR_1 $LOCAL_SAVESTATES_DIR_1
download_files $MISTER_2_IP $LOCAL_SAVEGAMES_DIR_2 $LOCAL_SAVESTATES_DIR_2

# Synchronise savegames between the local directories
rsync -a --delete $LOCAL_SAVEGAMES_DIR_1/ $LOCAL_SAVEGAMES_DIR_2/
rsync -a --delete $LOCAL_SAVEGAMES_DIR_2/ $LOCAL_SAVEGAMES_DIR_1/

# Synchronise savestates between the local directories
rsync -a --delete $LOCAL_SAVESTATES_DIR_1/ $LOCAL_SAVESTATES_DIR_2/
rsync -a --delete $LOCAL_SAVESTATES_DIR_2/ $LOCAL_SAVESTATES_DIR_1/

# Upload files to both Misters
upload_files $MISTER_1_IP $LOCAL_SAVEGAMES_DIR_1 $LOCAL_SAVESTATES_DIR_1
upload_files $MISTER_2_IP $LOCAL_SAVEGAMES_DIR_2 $LOCAL_SAVESTATES_DIR_2

# Replace this with your own backup directory
BACKUP_DIR="your_backup_directory"
DATE=$(date +%d-%m-%Y-%H-%M-%S)
zip -r $BACKUP_DIR/backup_savegames_$DATE.zip $LOCAL_SAVEGAMES_DIR_1
zip -r $BACKUP_DIR/backup_savestates_$DATE.zip $LOCAL_SAVESTATES_DIR_1
