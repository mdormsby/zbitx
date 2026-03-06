# zBitx Release Images for Raspberry Pi

This folder tracks the release process for zBitx. Binary release archives for
the Raspberry Pi are produced automatically by the [release workflow](../.github/workflows/release.yml)
and attached to each GitHub Release.

## Release Contents

Each release archive (`zbitx-<version>-rpi.tar.gz`) contains the following
files ready to deploy to a Raspberry Pi running Raspberry Pi OS:

```
zbitx/
├── sbitx              # compiled ARM binary
├── start.sh           # startup script
├── update             # update helper script
├── update_zbitx       # update helper script (zBitx fork)
├── sbitx_user_settings.ini
├── sbitx_wisdom.wis
├── sbitx_wisdom_f.wis
├── data/              # database schema and default settings
└── web/               # web UI assets
```

## Creating a Release

1. Push a version tag to GitHub:
   ```sh
   git tag v3.052
   git push origin v3.052
   ```
2. Create a GitHub Release from that tag (via the GitHub UI or `gh release create`).
3. The release workflow will cross-compile `sbitx` for ARM and upload
   `zbitx-<version>-rpi.tar.gz` as a release asset automatically.

## Installing on a Raspberry Pi

```sh
# Find the version-specific archive name on the GitHub Releases page, e.g.:
#   https://github.com/mdormsby/zbitx/releases

# Download the release archive (replace <version> with the actual version):
curl -LO https://github.com/mdormsby/zbitx/releases/latest/download/zbitx-<version>-rpi.tar.gz

# Extract to your home directory
tar -xzf zbitx-<version>-rpi.tar.gz -C /home/pi/

# Follow the rest of the setup in install.txt
```
