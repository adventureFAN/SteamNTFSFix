#!/bin/bash

# SteamNTFSFix - GUI tool to relocate Proton prefixes from NTFS to Linux-native drives
# Dependencies: zenity, rsync

# Ask user where to store fixed prefixes
TARGET_DIR=$(zenity --file-selection \
    --directory \
    --title="Select Linux-native directory (e.g. ext4) to store fixed Proton prefixes")

[ -z "$TARGET_DIR" ] && exit 0

# Ask user to select the broken compatdata folder
SOURCE_PREFIX=$(zenity --file-selection \
    --directory \
    --title="Select the broken 'compatdata/<APPID>' folder on your NTFS Steam library")

[ -z "$SOURCE_PREFIX" ] && exit 0

APPID=$(basename "$SOURCE_PREFIX")
DEST_PREFIX="$TARGET_DIR/$APPID"

# Copy data
mkdir -p "$DEST_PREFIX"
zenity --info --text="Copying data... please wait."
rsync -a "$SOURCE_PREFIX/" "$DEST_PREFIX/"

# Backup original and create symlink
TIMESTAMP=$(date +%s)
mv "$SOURCE_PREFIX" "${SOURCE_PREFIX}_backup_$TIMESTAMP"
ln -s "$DEST_PREFIX" "$SOURCE_PREFIX"

zenity --info --text="✅ Done! Proton prefix for AppID $APPID moved and linked."
