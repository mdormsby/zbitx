#!/bin/sh -e
# make_release.sh - Build sbitx, tag the release, and package it into release/
#
# Run this script on a Raspberry Pi (or with a cross-compilation toolchain
# already set up) to produce a tagged release archive.
#
# Usage:
#   ./make_release.sh              # builds release candidate (e.g. v3.052-rc1)
#   ./make_release.sh v3.052       # builds final release with given tag
#   ./make_release.sh v3.052-rc2   # builds a specific release candidate

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
date

# Determine the version string from source.
# VER_STR is defined as e.g. "sbitx v3.052"; the last word (NF) is the semver part.
CODE_VERSION=$(grep '#define VER_STR' sdr_ui.h | awk '{print $4}' | sed -e 's/"//g' | awk '{print $NF}')

# Accept an optional tag argument; default to <version>-rc1
if [ -n "$1" ]; then
  TAG="$1"
else
  TAG="${CODE_VERSION}-rc1"
fi

ARCHIVE="zbitx-${TAG}-rpi.tar.gz"

echo "Version : ${CODE_VERSION}"
echo "Tag     : ${TAG}"
echo "Archive : ${ARCHIVE}"

# Build the sbitx binary using the existing build script
chmod +x build
./build sbitx

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

# Create and push the git tag so the CI release workflow can be triggered
# (skip if the tag already exists locally or if not in a git repo)
if git rev-parse --git-dir > /dev/null 2>&1; then
  if git rev-parse "$TAG" > /dev/null 2>&1; then
    echo "Tag ${TAG} already exists; skipping tag creation."
  else
    git tag -a "${TAG}" -m "Release ${TAG}"
    echo "Created tag: ${TAG}"
    echo "Push the tag to trigger the CI release workflow:"
    echo "  git push origin ${TAG}"
  fi
fi

echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
