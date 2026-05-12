#!/bin/bash
set -e  # Exit immediately if a command fails

echo "=== Starting libraries and wget install on RG501 ==="

# 1. Ensure the partition is writable
echo "Remounting / as read-write..."
mount -o remount,rw /

# 2. Cleanup any broken/corrupt files from previous failed installs
echo "Cleaning up any previous broken files in /usr/lib ..."
rm -f /usr/lib/libgnutls.so.30    /usr/lib/libgnutls.so.30.22.0
rm -f /usr/lib/libhogweed.so.4    /usr/lib/libhogweed.so.4.4
rm -f /usr/lib/libidn2.so.0       /usr/lib/libidn2.so.0.3.4
rm -f /usr/lib/libnettle.so.6     /usr/lib/libnettle.so.6.4
rm -f /usr/lib/libunistring.so.2  /usr/lib/libunistring.so.2.1.0

# 3. Download files directly from GitHub
# Source: https://github.com/ikhsanh/wget-rg501q
GITHUB_RAW="https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main"
TMP_DIR="/tmp/wget_install"

# Create temporary directory
mkdir -p "$TMP_DIR"

# Download function: tries curl first, falls back to busybox wget
download() {
    local url="$1"
    local filename="$2"
    local tmp_path="$TMP_DIR/$filename"
    echo "  -> Downloading $filename to $TMP_DIR ..."
    if curl -fsSL -o "$tmp_path" "$url" 2>/dev/null; then
        echo "     [OK] curl"
    elif busybox wget -O "$tmp_path" "$url" 2>/dev/null; then
        echo "     [OK] busybox wget"
    else
        echo "ERROR: Failed to download $url (curl and busybox wget both failed)"
        exit 1
    fi
}

echo "Downloading libraries to $TMP_DIR ..."
download "$GITHUB_RAW/libgnutls.so.30.22.0"  "libgnutls.so.30.22.0"
download "$GITHUB_RAW/libhogweed.so.4"        "libhogweed.so.4.4"
download "$GITHUB_RAW/libidn2.so.0"           "libidn2.so.0.3.4"
download "$GITHUB_RAW/libnettle.so.6.4"       "libnettle.so.6.4"
download "$GITHUB_RAW/libunistring.so.2.1.0"  "libunistring.so.2.1.0"

echo "Downloading wget to $TMP_DIR ..."
download "$GITHUB_RAW/wget" "wget"

echo "Download to $TMP_DIR complete."

# 4. Move files from /tmp to their final destinations
echo "Moving libraries from $TMP_DIR to /usr/lib ..."
mv "$TMP_DIR/libgnutls.so.30.22.0"  /usr/lib/libgnutls.so.30.22.0
mv "$TMP_DIR/libhogweed.so.4.4"     /usr/lib/libhogweed.so.4.4
mv "$TMP_DIR/libidn2.so.0.3.4"      /usr/lib/libidn2.so.0.3.4
mv "$TMP_DIR/libnettle.so.6.4"      /usr/lib/libnettle.so.6.4
mv "$TMP_DIR/libunistring.so.2.1.0" /usr/lib/libunistring.so.2.1.0

echo "Moving wget from $TMP_DIR to /usr/bin ..."
mv "$TMP_DIR/wget" /usr/bin/wget

# Cleanup temp directory
rm -rf "$TMP_DIR"
echo "Temporary files cleaned up."

# 5. Set permissions and create symlinks
echo "Setting permissions and symbolic links..."
cd /usr/lib || { echo "ERROR: Failed to change directory to /usr/lib"; exit 1; }

# Set correct permissions (755) for libraries and wget
chmod 755 libgnutls.so.30.22.0
chmod 755 libhogweed.so.4.4
chmod 755 libidn2.so.0.3.4
chmod 755 libnettle.so.6.4
chmod 755 libunistring.so.2.1.0
chmod 755 /usr/bin/wget

# Set owner to root:root
chown root:root libgnutls.so.30.22.0 libhogweed.so.4.4 libidn2.so.0.3.4 libnettle.so.6.4 libunistring.so.2.1.0
chown root:root /usr/bin/wget

# Create symbolic links
ln -s libgnutls.so.30.22.0  libgnutls.so.30
ln -s libhogweed.so.4.4     libhogweed.so.4
ln -s libidn2.so.0.3.4      libidn2.so.0
ln -s libnettle.so.6.4      libnettle.so.6
ln -s libunistring.so.2.1.0 libunistring.so.2

echo "=== Verification (Libraries) ==="
ls -l libgnu* libhog* libidn* libnett* libun*

echo "=== Verification (Wget) ==="
ls -l /usr/bin/wget

echo "=== Process completed successfully! ==="
