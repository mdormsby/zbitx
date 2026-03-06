#!/bin/sh -e
# make_release.sh - Build sbitx and package it as a release archive in release/
#
# Run this script on a Raspberry Pi (or with a cross-compilation toolchain
# already set up) to produce a release archive.
#
# Usage: ./make_release.sh

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
date

# Build the sbitx binary using the existing build script
chmod +x build
./build sbitx

# Determine the version string
VERSION=$(grep '#define VER_STR' sdr_ui.h | awk '{print $4}' | sed -e 's/"//g')
ARCHIVE="zbitx-${VERSION}-rpi.tar.gz"

echo "Packaging release: ${ARCHIVE}"

# Create the staging directory and release output directory
mkdir -p release release_pkg/zbitx

# Copy the compiled binary
cp sbitx release_pkg/zbitx/

# Copy runtime scripts and configuration
cp start.sh update update_zbitx release_pkg/zbitx/
cp sbitx_user_settings.ini sbitx_wisdom.wis sbitx_wisdom_f.wis release_pkg/zbitx/

# Copy data and web directories
cp -r data web release_pkg/zbitx/

# Create the archive in the release folder
tar -czf "release/${ARCHIVE}" -C release_pkg zbitx

# Clean up staging directory
rm -rf release_pkg

echo "Release image created: release/${ARCHIVE}"
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
