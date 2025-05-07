# doas-keepenv
A shell script for running the doas command while keeping environment variables, make to replicate `sudo -E` behaviour for the `doas` command

## Usage
Exactly like you would use doas, but some features might not work (normal `doas dorootthings` works rest is not tested)

## Install from package repo:
- `yay -S doas-keepenv` ([https://aur.archlinux.org/packages/doas-keepenv](https://aur.archlinux.org/packages/doas-keepenv))

## Packaging

### avilable package fromats
- `.deb` (Debian and derivitives)
- `.rpm` (RHEL and derivitives)
- `.pkg.tar.`(`zst`/`xz`/`gz`) (Arch Linux and derivitives)

### build package from source
`make v=1.0`

### install package
(`su -c`/`doas`/`sudo`) `make install v=1.0`

## Notice
This script changes to /etc/doas.conf while the subprocess is running and it will will be reverted only after the subprocess exits
