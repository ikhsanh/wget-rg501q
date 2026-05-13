#!/bin/bash
# =============================================================================
# install_wget.sh — wget installer for Quectel RG501Q
# Install directly from the modem terminal (SSH / root shell) without ADB
# Source files: https://github.com/ikhsanh/wget-rg501q
# =============================================================================

set -e

GITHUB_RAW="https://raw.githubusercontent.com/ikhsanh/wget-rg501q/main"
TMP_DIR="/tmp"

# Warna output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  wget Installer - Quectel RG501Q          ${NC}"
echo -e "${CYAN}  Source: github.com/ikhsanh/wget-rg501q   ${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# -----------------------------------------------------------------------------
# Check if curl is available
# -----------------------------------------------------------------------------
if ! command -v curl > /dev/null 2>&1; then
    echo -e "${RED}[ERROR] curl not found. curl is required to download files.${NC}"
    exit 1
fi

# -----------------------------------------------------------------------------
# Remount root filesystem as read-write
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[1/4] Remounting root filesystem as read-write...${NC}"
if mount -o remount,rw / 2>/dev/null; then
    echo -e "${GREEN}      OK: Filesystem successfully remounted rw${NC}"
else
    echo -e "${YELLOW}      WARN: Remount failed (may already be rw or not required), continuing...${NC}"
fi
echo ""

# -----------------------------------------------------------------------------
# STEP 1: Download all files to /tmp
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[2/4] Downloading files to ${TMP_DIR}...${NC}"

download_file() {
    local filename="$1"
    local url="${GITHUB_RAW}/${filename}"
    echo -e "      Downloading: ${filename}"
    if curl -fsSL -o "${TMP_DIR}/${filename}" "${url}"; then
        echo -e "${GREEN}      OK: ${filename}${NC}"
    else
        echo -e "${RED}      FAILED to download: ${filename}${NC}"
        echo -e "${RED}      URL: ${url}${NC}"
        exit 1
    fi
}

download_file "libgnutls.so.30.22.0"
download_file "libhogweed.so.4"
download_file "libidn2.so.0"
download_file "libnettle.so.6.4"
download_file "libunistring.so.2.1.0"
download_file "wget"
echo ""

# -----------------------------------------------------------------------------
# STEP 2: Move files to the correct directories
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[3/4] Moving files to target directories...${NC}"

# Libraries → /usr/lib (with correct destination filename)
mv -f "${TMP_DIR}/libgnutls.so.30.22.0"  /usr/lib/libgnutls.so.30.22.0
echo -e "${GREEN}      OK: libgnutls.so.30.22.0  → /usr/lib/libgnutls.so.30.22.0${NC}"

mv -f "${TMP_DIR}/libhogweed.so.4"        /usr/lib/libhogweed.so.4.4
echo -e "${GREEN}      OK: libhogweed.so.4       → /usr/lib/libhogweed.so.4.4${NC}"

mv -f "${TMP_DIR}/libidn2.so.0"           /usr/lib/libidn2.so.0.3.4
echo -e "${GREEN}      OK: libidn2.so.0          → /usr/lib/libidn2.so.0.3.4${NC}"

mv -f "${TMP_DIR}/libnettle.so.6.4"       /usr/lib/libnettle.so.6.4
echo -e "${GREEN}      OK: libnettle.so.6.4      → /usr/lib/libnettle.so.6.4${NC}"

mv -f "${TMP_DIR}/libunistring.so.2.1.0"  /usr/lib/libunistring.so.2.1.0
echo -e "${GREEN}      OK: libunistring.so.2.1.0 → /usr/lib/libunistring.so.2.1.0${NC}"

# wget binary → /usr/bin/wget
mv -f "${TMP_DIR}/wget"                   /usr/bin/wget
echo -e "${GREEN}      OK: wget                  → /usr/bin/wget${NC}"
echo ""

# -----------------------------------------------------------------------------
# STEP 3: Set permissions, ownership, and create symlinks
# -----------------------------------------------------------------------------
echo -e "${YELLOW}[4/4] Setting permissions, ownership, and creating symlinks...${NC}"

cd /usr/lib

# Remove old symlinks (if any) to avoid ln -s errors
echo -e "      Removing old symlinks (if any)..."
rm -f libgnutls.so.30 libhogweed.so.4 libidn2.so.0 libnettle.so.6 libunistring.so.2

# Set permissions 755
echo -e "      Setting permissions 755..."
chmod 755 libgnutls.so.30.22.0
chmod 755 libhogweed.so.4.4
chmod 755 libidn2.so.0.3.4
chmod 755 libnettle.so.6.4
chmod 755 libunistring.so.2.1.0
chmod 755 /usr/bin/wget

# Set ownership root:root
echo -e "      Setting ownership to root:root..."
chown root:root libgnutls.so.30.22.0
chown root:root libhogweed.so.4.4
chown root:root libidn2.so.0.3.4
chown root:root libnettle.so.6.4
chown root:root libunistring.so.2.1.0
chown root:root /usr/bin/wget

# Create symbolic links
echo -e "      Creating symbolic links..."
ln -s libgnutls.so.30.22.0  libgnutls.so.30
ln -s libhogweed.so.4.4     libhogweed.so.4
ln -s libidn2.so.0.3.4      libidn2.so.0
ln -s libnettle.so.6.4      libnettle.so.6
ln -s libunistring.so.2.1.0 libunistring.so.2

echo -e "${GREEN}      OK: All symlinks created successfully${NC}"
echo ""

# -----------------------------------------------------------------------------
# Verify installation results
# -----------------------------------------------------------------------------
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  INSTALLATION VERIFICATION                ${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo -e "${YELLOW}Libraries in /usr/lib:${NC}"
ls -l /usr/lib/libgnu* /usr/lib/libhog* /usr/lib/libidn* /usr/lib/libnett* /usr/lib/libun*
echo ""
echo -e "${YELLOW}wget binary:${NC}"
ls -l /usr/bin/wget
echo ""

# Test wget --version
echo -e "${YELLOW}wget version:${NC}"
if /usr/bin/wget --version 2>/dev/null | head -1; then
    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  INSTALLATION SUCCESSFUL!                 ${NC}"
    echo -e "${GREEN}  wget is ready to use.                    ${NC}"
    echo -e "${GREEN}============================================${NC}"
else
    echo -e "${RED}[WARN] wget installed but failed to execute.${NC}"
    echo -e "${RED}       Check if all libraries are correct.  ${NC}"
fi
