#!/bin/bash

# Fill in your FTP details
FTP_USER="YOUR_FTP_USERNAME" # default is "root"
FTP_PASS="YOUR_FTP_PASSWORD" # default is "1"

# Fill in your MiSTer IP addresses
MISTER_1_IP="YOUR_MISTER_1_IP"
MISTER_2_IP="YOUR_MISTER_2_IP"

# Trigger file path (this should be the same on all MiSTer devices)
TRIGGER_FILE="/media/fat/trigger.txt"

# Path to the sync script on your Pi (update this if you have placed the script in a different location)
SYNC_SCRIPT_PATH="/etc/MiSTerSaveGames.sh"

# Function to check for trigger file and start sync
check_trigger_and_sync() {
    local MISTER_IP=$1

    echo "Checking trigger and sync for $MISTER_IP"

    # Check if the MiSTer device is active
    if ping -c 1 $MISTER_IP &> /dev/null
    then
        echo "MiSTer at $MISTER_IP is active."
        echo "Checking if trigger file exists."

        # Check if the trigger file exists on the MiSTer device
        FTP_OUTPUT=$(lftp -f "
        open $MISTER_IP
        user $FTP_USER $FTP_PASS
        ls $TRIGGER_FILE
        bye
        ")

        # If the trigger file exists, remove it and start the sync script
        if [[ $FTP_OUTPUT == *"$TRIGGER_FILE"* ]]
        then
            echo "Trigger file exists. Removing trigger file and starting sync script."

            # Remove the trigger file from the MiSTer device
            lftp -f "
            open $MISTER_IP
            user $FTP_USER $FTP_PASS
            rm $TRIGGER_FILE
            bye
            "

            # Start the sync script
            $SYNC_SCRIPT_PATH

            # Stop the script after a synchronization has been performed
            exit 0
        else
            echo "Trigger file does not exist."
        fi
    else
        echo "MiSTer at $MISTER_IP is not active. Skipping check."
    fi
}

# Check for trigger file and start sync for both MiSTer devices
check_trigger_and_sync $MISTER_1_IP
check_trigger_and_sync $MISTER_2_IP
