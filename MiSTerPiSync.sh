#!/bin/bash

# Create the trigger file
echo "Triggering sync on Raspberry Pi" > /media/fat/trigger.txt

# Inform the user and wait for 10 seconds
echo "Sync initiated. Waiting for 10 seconds before returning to main menu..."
sleep 10

# Exit the script, returning to the main menu
exit 0
