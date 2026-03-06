# zBitx Release Images for Raspberry Pi

This folder stores release archives produced by the
[release workflow](../.github/workflows/release.yml).  Each archive is also
attached to the corresponding [GitHub Release](https://github.com/mdormsby/zbitx/releases)
for download.

## Release Contents

Each release archive (`zbitx-<tag>-rpi.tar.gz`) contains the following files
ready to deploy to a Raspberry Pi running Raspberry Pi OS:

```
zbitx/
├── sbitx              # compiled ARMhf binary
├── start.sh           # startup script
├── update             # update helper script
├── update_zbitx       # update helper script (zBitx fork)
├── sbitx_user_settings.ini
├── sbitx_wisdom.wis
├── sbitx_wisdom_f.wis
├── data/              # database schema and default settings
└── web/               # web UI assets
```

## Creating a Release Candidate (CI workflow)

The easiest way to cut a release candidate is via the GitHub Actions
**workflow_dispatch** trigger — no local toolchain needed:

1. Go to **Actions → Release → Run workflow** on GitHub.
2. Enter the tag (e.g. `v3.052-rc1`).  Leave blank to auto-generate
   `<version>-rc1` from the version in `sdr_ui.h`.
3. Check **Mark as pre-release** for a release candidate.
4. Click **Run workflow**.

The workflow will:
- Create and push the git tag.
- Cross-compile `sbitx` for ARMhf.
- Package the archive and commit it to this folder.
- Publish a GitHub Pre-Release with the archive attached.

## Creating a Release from a Tag (CI workflow)

To build a final (non-pre-release) from a manually pushed tag:

```sh
git tag -a v3.052 -m "Release v3.052"
git push origin v3.052
```

The release workflow will build the archive, commit it here, and create a
GitHub Release automatically.

## Creating a Release Locally

```sh
# Default: builds release candidate tagged <version>-rc1
./make_release.sh

# Build with a specific tag
./make_release.sh v3.052

# Then push the generated tag to trigger CI
git push origin v3.052-rc1
```

## Installing on a Raspberry Pi

```sh
# Download the latest release (replace <tag> with the actual tag, e.g. v3.052):
curl -LO https://github.com/mdormsby/zbitx/releases/latest/download/zbitx-<tag>-rpi.tar.gz

# Extract to your home directory
tar -xzf zbitx-<tag>-rpi.tar.gz -C /home/pi/

# Follow the rest of the setup in install.txt
```
