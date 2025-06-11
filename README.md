# SteamNTFSFix ⚙

## 🐞 Problem

Steam Proton’s compatibility data (`compatdata`) stored on NTFS partitions can cause issues (missing symlinks, permissions, etc.). This script helps you move these data folders to a native Linux ext4 partition and creates symlinks pointing from the NTFS location to the new ext4 location so Steam can find them seamlessly.


## ✨ Features

- 🖥️ Simple GUI using Zenity for selecting NTFS and ext4 directories  
- 💾 Saves your chosen paths in a config file for future runs  
- 🎮 Enter the Steam App ID of the game you want to fix  
- 🔗 Automatically creates a symlink from the NTFS compatdata folder to the ext4 folder  
- 🔄 Ask if you want to fix more games in a loop  

## 📋 Requirements

- 🐧 Linux system with Bash  
- 🪟 Zenity installed for GUI dialogs  
- 🎲 Steam Proton games installed on NTFS


## 🚀 Usage

1. Download and run the script:  
   ```bash
   chmod +x steamntfsfix.sh
   ./steamntfsfix.sh
2. On first run, you’ll be prompted to select the NTFS source (`compatdata`) folder on your NTFS drive) and the target folder on your ext4 partition.
3. Enter the Steam App ID of the game you want to fix (make sure you have launched the game at least once).
4. The script will create the symlink allowing Steam to find the Proton data correctly.
5. You’ll be asked if you want to fix another game.
6. Your selected paths are saved in (`~/.config/steamntfsfix.conf`) so you won’t need to enter them again next time.
7. If saved paths exist, the script will ask if you want to change them before proceeding.

## ⚠️ Notes

- The script does not create backups, since the moved data on the ext4 partition effectively serves as the backup. If you want to revert, you can manually copy the data back.
- Intended for advanced users who understand the process and risks.
- Always double-check your selected paths to avoid data loss.
