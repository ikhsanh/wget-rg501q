# wget for RG501Q

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

That's it. The command will automatically:
1. Remount `/` as read-write
2. Download all required libraries and the `wget` binary from this repository
3. Set correct permissions (`755`) and ownership (`root:root`)
4. Create the necessary symbolic links
5. Display a verification output

### Verify the installation

```sh
wget --version
```

---

### Alternative — Step by Step

If you prefer to review the script before running it:

**Step 1** — Connect to the device via SSH:
```sh
ssh root@<device-ip>
```

**Step 2** — Download the script:
```sh
curl -fsSL -o install_wget.sh https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main/install_wget.sh
```

**Step 3** — Make it executable and run:
```sh
chmod +x install_wget.sh && ./install_wget.sh
```

**Step 4** — Verify:
```sh
wget --version
```

Expected output example:
```
GNU Wget 1.x.x built on linux-gnu.
...
```

---

## Manual Installation (optional)

If you prefer to run the commands manually instead of using the script:

```sh
# 1. Remount root as writable
mount -o remount,rw /

# 2. Set base URL
GITHUB_RAW="https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main"

# 3. Download libraries
curl -fsSL -o /usr/lib/libgnutls.so.30.22.0  "$GITHUB_RAW/libgnutls.so.30.22.0"
curl -fsSL -o /usr/lib/libhogweed.so.4.4     "$GITHUB_RAW/libhogweed.so.4"
curl -fsSL -o /usr/lib/libidn2.so.0.3.4      "$GITHUB_RAW/libidn2.so.0"
curl -fsSL -o /usr/lib/libnettle.so.6.4      "$GITHUB_RAW/libnettle.so.6.4"
curl -fsSL -o /usr/lib/libunistring.so.2.1.0 "$GITHUB_RAW/libunistring.so.2.1.0"
curl -fsSL -o /usr/bin/wget                  "$GITHUB_RAW/wget"

# 4. Set permissions and ownership
cd /usr/lib
chmod 755 libgnutls.so.30.22.0 libhogweed.so.4.4 libidn2.so.0.3.4 libnettle.so.6.4 libunistring.so.2.1.0
chmod 755 /usr/bin/wget
chown root:root libgnutls.so.30.22.0 libhogweed.so.4.4 libidn2.so.0.3.4 libnettle.so.6.4 libunistring.so.2.1.0
chown root:root /usr/bin/wget

# 5. Create symbolic links
ln -s libgnutls.so.30.22.0  libgnutls.so.30
ln -s libhogweed.so.4.4     libhogweed.so.4
ln -s libidn2.so.0.3.4      libidn2.so.0
ln -s libnettle.so.6.4      libnettle.so.6
ln -s libunistring.so.2.1.0 libunistring.so.2
```

---

## Troubleshooting

| Error | Cause | Solution |
|---|---|---|
| `curl: command not found` | `curl` is not installed | Use a package manager or flash a firmware that includes `curl` |
| `mount: permission denied` | Not running as root | Run the script as root: `sudo ./install_wget.sh` |
| `Failed to download ...` | No internet on device | Check the device's network/APN settings |
| `File exists` on `ln -s` | Old symlinks present | Run `rm -f /usr/lib/libgnutls.so.30 ...` then re-run the script |
| `wget: error while loading shared libraries` | Symlinks missing or wrong path | Re-run the script to recreate symlinks |

---

## License

This repository provides pre-compiled binaries for use on the Quectel RG501Q platform.  
Source packages are available from their respective upstream projects.
