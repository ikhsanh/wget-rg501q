# wget for Quectel RG501Q

Install `wget` and its required libraries on the **Quectel RG501Q** modem directly from the device terminal (SSH / root shell) — no ADB required.

---

## Requirements
- Root access to the device (via SSH or serial terminal)
- Internet connection on the device
- `curl` available on the device

---

## Files Installed

| File (on device) | Description |
|---|---|
| `/usr/lib/libgnutls.so.30.22.0` | GnuTLS library |
| `/usr/lib/libhogweed.so.4.4` | Nettle hogweed crypto library |
| `/usr/lib/libidn2.so.0.3.4` | IDN2 internationalized domain names library |
| `/usr/lib/libnettle.so.6.4` | Nettle low-level crypto library |
| `/usr/lib/libunistring.so.2.1.0` | Unicode string library |
| `/usr/bin/wget` | wget binary |

Symbolic links are also created automatically:
- `libgnutls.so.30` → `libgnutls.so.30.22.0`
- `libhogweed.so.4` → `libhogweed.so.4.4`
- `libidn2.so.0` → `libidn2.so.0.3.4`
- `libnettle.so.6` → `libnettle.so.6.4`
- `libunistring.so.2` → `libunistring.so.2.1.0`

---

## Installation

### ⚡ One-Line Install (Recommended)
SSH into the device, then paste this single command:

```sh
curl -fsSL https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main/install_wget.sh | bash
```

The script will automatically perform the following steps:
1. Remount `/` as read-write
2. Download all required files to `/tmp` using `curl`
3. Move each file from `/tmp` to its correct destination directory
4. Set correct permissions (`755`) and ownership (`root:root`)
5. Remove any old symlinks, then create new ones
6. Display a verification output

### Verify the installation
```sh
wget --version
```

Expected output example:
```
GNU Wget 1.x.x built on linux-gnu.
...
```

---

### Alternative — Step by Step
If you prefer to review the script before running it:

**Step 1** — Connect to the device via SSH:
```sh
ssh root@<device-ip>
```

**Step 2** — Download the script to `/tmp`:
```sh
curl -fsSL -o /tmp/install_wget.sh https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main/install_wget.sh
```

**Step 3** — Make it executable and run:
```sh
chmod +x /tmp/install_wget.sh && /tmp/install_wget.sh
```

**Step 4** — Verify:
```sh
wget --version
```

---

## Manual Installation (optional)
If you prefer to run the commands manually instead of using the script:

```sh
# 1. Remount root as writable
mount -o remount,rw /

# 2. Set base URL
GITHUB_RAW="https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main"

# 3. Download all files to /tmp
curl -fsSL -o /tmp/libgnutls.so.30.22.0  "$GITHUB_RAW/libgnutls.so.30.22.0"
curl -fsSL -o /tmp/libhogweed.so.4        "$GITHUB_RAW/libhogweed.so.4"
curl -fsSL -o /tmp/libidn2.so.0           "$GITHUB_RAW/libidn2.so.0"
curl -fsSL -o /tmp/libnettle.so.6.4       "$GITHUB_RAW/libnettle.so.6.4"
curl -fsSL -o /tmp/libunistring.so.2.1.0  "$GITHUB_RAW/libunistring.so.2.1.0"
curl -fsSL -o /tmp/wget                   "$GITHUB_RAW/wget"

# 4. Move files to the correct directories
mv -f /tmp/libgnutls.so.30.22.0  /usr/lib/libgnutls.so.30.22.0
mv -f /tmp/libhogweed.so.4        /usr/lib/libhogweed.so.4.4
mv -f /tmp/libidn2.so.0           /usr/lib/libidn2.so.0.3.4
mv -f /tmp/libnettle.so.6.4       /usr/lib/libnettle.so.6.4
mv -f /tmp/libunistring.so.2.1.0  /usr/lib/libunistring.so.2.1.0
mv -f /tmp/wget                   /usr/bin/wget

# 5. Set permissions and ownership
cd /usr/lib
chmod 755 libgnutls.so.30.22.0 libhogweed.so.4.4 libidn2.so.0.3.4 libnettle.so.6.4 libunistring.so.2.1.0
chmod 755 /usr/bin/wget
chown root:root libgnutls.so.30.22.0 libhogweed.so.4.4 libidn2.so.0.3.4 libnettle.so.6.4 libunistring.so.2.1.0
chown root:root /usr/bin/wget

# 6. Remove old symlinks (if any), then create new ones
rm -f libgnutls.so.30 libhogweed.so.4 libidn2.so.0 libnettle.so.6 libunistring.so.2
ln -s libgnutls.so.30.22.0  libgnutls.so.30
ln -s libhogweed.so.4.4     libhogweed.so.4
ln -s libidn2.so.0.3.4      libidn2.so.0
ln -s libnettle.so.6.4      libnettle.so.6
ln -s libunistring.so.2.1.0 libunistring.so.2

# 7. Verify
ls -l libgnu* libhog* libidn* libnett* libun*
ls -l /usr/bin/wget
wget --version
```

---

## Uninstallation
To completely remove `wget` and all installed libraries, run this one-liner on the device terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main/uninstall_wget.sh | bash
```

The script will remove:
- `/usr/bin/wget` — wget binary
- `/usr/lib/libgnutls.so.30.22.0` and symlink `libgnutls.so.30`
- `/usr/lib/libhogweed.so.4.4` and symlink `libhogweed.so.4`
- `/usr/lib/libidn2.so.0.3.4` and symlink `libidn2.so.0`
- `/usr/lib/libnettle.so.6.4` and symlink `libnettle.so.6`
- `/usr/lib/libunistring.so.2.1.0` and symlink `libunistring.so.2`

---

## Troubleshooting

| Error | Cause | Solution |
|---|---|---|
| `curl: command not found` | `curl` is not installed | Use a package manager or flash a firmware that includes `curl` |
| `mount: permission denied` | Not running as root | Run the script as root: `sudo /tmp/install_wget.sh` |
| `Failed to download ...` | No internet on device | Check the device's network/APN settings |
| `File exists` on `ln -s` | Old symlinks present | The script removes old symlinks automatically before creating new ones |
| `wget: error while loading shared libraries` | Symlinks missing or wrong path | Re-run the script to recreate symlinks |

---

## License
This repository provides pre-compiled binaries for use on the Quectel RG501Q platform.  
Source packages are available from their respective upstream projects.
