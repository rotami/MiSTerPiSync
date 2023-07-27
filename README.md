# MiSTerPiSync
This project provides a simple solution for synchronizing save game files between two or more MiSTer FPGA devices via a Raspberry Pi. The Pi acts as an intermediary, periodically checking for a trigger file on the MiSTer devices, and if found, synchronizing the save files between them.

# Getting Started
# 1. Setup your Raspberry Pi
You'll need a Raspberry Pi set up with a Unix-based OS (like Raspbian) and connected to the same network as your MiSTer devices. Ensure you have FTP and lftp installed. If not, you can install them using the following commands:
```
sudo apt-get update
sudo apt-get install ftp lftp
```

# 2 Install Scripts on Raspberry Pi
Clone this repository and copy the scripts MiSTerTrigger.sh and MiSTerSaveGames.sh into your /etc directory:
```
git clone https://github.com/rotami/MiSTerPiSync.git
sudo cp MiSTerPiSync/MiSTerTrigger.sh /etc/
sudo cp MiSTerPiSync/MiSTerSaveGames.sh /etc/
```
Remember to update the scripts with your specific details (IP addresses, FTP usernames and passwords). You edit the files with command: sudo nano /etc/MiSTerSaveGames.sh and sudo nano /etc/MiSTerTrigger.sh

# 3. Set Permissions on Scripts
Ensure the scripts are executable:
```
sudo chmod +x /etc/MiSTerTrigger.sh
sudo chmod +x /etc/MiSTerSaveGames.sh
```

# 4. Setup MiSTer Devices
Your MiSTer devices need to be setup to allow FTP access. This is typically done in the MiSTer's INI file. If you haven't done this, please consult the MiSTer FPGA project's documentation.

Ensure that your MiSTer devices are connected to the same network as your Raspberry Pi.

# 5. Install Scripts on MiSTer Devices
Copy the MiSTerSync.sh script to the scripts directory of your MiSTer devices.

# 6. Setup Cron Jobs
Cron jobs need to be set up on your Raspberry Pi to run the scripts at regular intervals. Open the crontab editor:
```
crontab -e

```
Add the following lines at the end of the file:
```
```ruby
* * * * * /etc/MiSTerTrigger.sh > /dev/null 2>&1
@reboot /etc/MiSTerTrigger.sh > /dev/null 2>&1
```
Save and close the file.

# Usage
On your MiSTer device, run the MiSTerSync.sh script when you want to trigger a sync. This will create a trigger file that the Pi will detect, initiating the synchronization process.

# Troubleshooting
Make sure that the IP addresses, FTP usernames and passwords in your scripts match those of your MiSTer devices and that they're connected to the same network as your Pi. Also make sure to use static ip-adresses on your router. Otherwise the ip-adresses will change from time to time and the script will fail. If you're still having issues, try running the scripts manually on your Pi and check the output for any error messages.
