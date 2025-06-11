# SteamNTFSFix

**Fix Steam + Proton compatibility issues when your Steam library is on an NTFS drive.**

SteamNTFSFix is a small GUI tool that moves Proton prefixes from an NTFS partition  
to a Linux-native location (e.g. ext4), and creates a symlink back. This avoids  
`OSError: Invalid argument` caused by Steam/Proton trying to use symlinks on NTFS.

---

## 🚀 Features

- Zenity-based GUI (no terminal typing needed)
- Backs up the original prefix folder
- Automatically handles symlink creation
- Works with any Steam + Proton setup on NTFS

---

## 🧰 Requirements

- `zenity`
- `rsync`
- Steam installed
- NTFS drive mounted with read/write access

---

## ⚙️ How to use

```bash
git clone https://github.com/adventureFAN/SteamNTFSFix.git
cd SteamNTFSFix
chmod +x steamntfsfix.sh
./steamntfsfix.sh
