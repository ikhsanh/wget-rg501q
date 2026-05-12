#!/bin/bash
set -e  # Exit immediately if a command fails

echo "=== Starting wget uninstall on RG501 ==="

# 1. Ensure the partition is writable
echo "Remounting / as read-write..."
mount -o remount,rw /

# 2. Remove symbolic links
echo "Removing symbolic links..."
cd /usr/lib || { echo "ERROR: Failed to change directory to /usr/lib"; exit 1; }

rm -f libgnutls.so.30
rm -f libhogweed.so.4
rm -f libidn2.so.0
rm -f libnettle.so.6
rm -f libunistring.so.2

# 3. Remove library files
echo "Removing library files..."
rm -f /usr/lib/libgnutls.so.30.22.0
rm -f /usr/lib/libhogweed.so.4.4
rm -f /usr/lib/libidn2.so.0.3.4
rm -f /usr/lib/libnettle.so.6.4
rm -f /usr/lib/libunistring.so.2.1.0

# 4. Remove wget binary
echo "Removing wget binary..."
rm -f /usr/bin/wget

# 5. Verify removal
echo "=== Verification ==="
echo "Checking /usr/lib ..."
for f in libgnutls.so.30.22.0 libgnutls.so.30 \
          libhogweed.so.4.4 libhogweed.so.4 \
          libidn2.so.0.3.4 libidn2.so.0 \
          libnettle.so.6.4 libnettle.so.6 \
          libunistring.so.2.1.0 libunistring.so.2; do
    if [ -e "/usr/lib/$f" ]; then
        echo "  [WARNING] Still exists: /usr/lib/$f"
    else
        echo "  [OK] Removed: /usr/lib/$f"
    fi
done

echo "Checking /usr/bin/wget ..."
if [ -e /usr/bin/wget ]; then
    echo "  [WARNING] Still exists: /usr/bin/wget"
else
    echo "  [OK] Removed: /usr/bin/wget"
fi

echo "=== Uninstall completed successfully! ==="
