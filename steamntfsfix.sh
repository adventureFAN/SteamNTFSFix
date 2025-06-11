#!/bin/bash

# Config-Datei für gespeicherte Pfade
CONFIG_FILE="$HOME/.steamntfsfix.conf"

# Funktion zum Speichern der Pfade
save_config() {
    echo "NTFS_COMPATDATA_DIR=\"$NTFS_COMPATDATA_DIR\"" > "$CONFIG_FILE"
    echo "EXT4_PREFIX_BASE=\"$EXT4_PREFIX_BASE\"" >> "$CONFIG_FILE"
}

# Funktion zur Auswahl eines Ordners via Zenity
select_directory() {
    local prompt="$1"
    zenity --file-selection --directory --title="$prompt"
}

# Funktion zum Laden gespeicherter Pfade (mit Änderungsdialog)
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # Vorherige Werte aus der Datei lesen
        source "$CONFIG_FILE"

        if [ -n "$NTFS_COMPATDATA_DIR" ] && [ -n "$EXT4_PREFIX_BASE" ]; then
            zenity --question --title="Use Saved Paths?" \
            --text="Current saved paths:

NTFS compatdata:
$NTFS_COMPATDATA_DIR

EXT4 target:
$EXT4_PREFIX_BASE

Do you want to change them?"
            
            if [ $? -eq 0 ]; then
                NTFS_COMPATDATA_DIR=$(select_directory "Select your NTFS Steam compatdata folder")
                [ -z "$NTFS_COMPATDATA_DIR" ] && zenity --error --text="No NTFS compatdata folder selected. Exiting." && exit 1

                EXT4_PREFIX_BASE=$(select_directory "Select target folder on ext4 partition")
                [ -z "$EXT4_PREFIX_BASE" ] && zenity --error --text="No target ext4 folder selected. Exiting." && exit 1

                save_config
            fi
        else
            # Einer der Werte fehlt oder ist leer
            NTFS_COMPATDATA_DIR=$(select_directory "Select your NTFS Steam compatdata folder")
            [ -z "$NTFS_COMPATDATA_DIR" ] && zenity --error --text="No NTFS compatdata folder selected. Exiting." && exit 1

            EXT4_PREFIX_BASE=$(select_directory "Select target folder on ext4 partition")
            [ -z "$EXT4_PREFIX_BASE" ] && zenity --error --text="No target ext4 folder selected. Exiting." && exit 1

            save_config
        fi
    else
        # Noch keine Config vorhanden
        NTFS_COMPATDATA_DIR=$(select_directory "Select your NTFS Steam compatdata folder")
        [ -z "$NTFS_COMPATDATA_DIR" ] && zenity --error --text="No NTFS compatdata folder selected. Exiting." && exit 1

        EXT4_PREFIX_BASE=$(select_directory "Select target folder on ext4 partition")
        [ -z "$EXT4_PREFIX_BASE" ] && zenity --error --text="No target ext4 folder selected. Exiting." && exit 1

        save_config
    fi
}

# Hauptfunktion zum Fixen eines Spiels
fix_game() {
    APPID=$(zenity --entry --title="SteamNTFSFix - Enter App ID" \
        --text="Enter the Steam App-ID to fix.  
Make sure you've started the game at least once in Steam.")

    [ -z "$APPID" ] && zenity --error --text="No App ID entered. Exiting." && exit 1

    SRC_DIR="$NTFS_COMPATDATA_DIR/$APPID"
    DST_DIR="$EXT4_PREFIX_BASE/$APPID"

    [ ! -d "$SRC_DIR" ] && zenity --error --text="Source folder does not exist:\n$SRC_DIR" && exit 1

    mkdir -p "$DST_DIR"

    # Lösche alten Prefix, egal ob Verzeichnis oder Symlink
    [ -L "$SRC_DIR" ] || [ -d "$SRC_DIR" ] && rm -rf "$SRC_DIR"

    ln -s "$DST_DIR" "$SRC_DIR"

    zenity --info --text="✅ Symlink created:\n$SRC_DIR → $DST_DIR"

    zenity --question --text="Do you want to fix another game?"
    return $?
}

# Hauptablauf
load_config

while true; do
    fix_game
    [ $? -ne 0 ] && break
done

echo "Bye!"
