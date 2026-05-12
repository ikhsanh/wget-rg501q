#!/bin/bash
set -e  # Exit immediately if a command fails

echo "=== Starting libraries and wget install on RG501 ==="

# 1. Ensure the partition is writable
echo "Remounting / as read-write..."
mount -o remount,rw /

# 2. Download files directly from GitHub
# Source: https://github.com/ikhsanh/wget-rg501q
GITHUB_RAW="https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main"

# Download function with error checking
download() {
    local url="$1"
    local dest="$2"
    echo "  -> $dest"
    curl -fsSL -o "$dest" "$url" || { echo "ERROR: Failed to download $url"; exit 1; }
}

echo "Downloading libraries to /usr/lib ..."
download "$GITHUB_RAW/libgnutls.so.30.22.0"  /usr/lib/libgnutls.so.30.22.0
download "$GITHUB_RAW/libhogweed.so.4"        /usr/lib/libhogweed.so.4.4
download "$GITHUB_RAW/libidn2.so.0"           /usr/lib/libidn2.so.0.3.4
download "$GITHUB_RAW/libnettle.so.6.4"       /usr/lib/libnettle.so.6.4
download "$GITHUB_RAW/libunistring.so.2.1.0"  /usr/lib/libunistring.so.2.1.0

echo "Downloading wget to /usr/bin ..."
download "$GITHUB_RAW/wget" /usr/bin/wget

echo "Download complete."

# 3. Set permissions and create symlinks
echo "Setting permissions and symbolic links..."
cd /usr/lib || { echo "ERROR: Failed to change directory to /usr/lib"; exit 1; }

# Remove any existing symlinks to avoid "File exists" errors
rm -f libgnutls.so.30 libhogweed.so.4 libidn2.so.0 libnettle.so.6 libunistring.so.2

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
