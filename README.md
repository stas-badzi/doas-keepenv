# doas-keepenv
A shell script for running the doas command while keeping environment variables, make to replicate `sudo -E` behaviour for the `doas` command

## Usage
Exactly like you would use doas, but some features might not work (normal `doas dorootthings` works rest is not tested)

## Install from package repo:
### Arch Linux (from [https://aur.archlinux.org/packages/doas-keepenv](https://aur.archlinux.org/packages/doas-keepenv))
1. Install [yay](https://github.com/Jguer/yay)
2. Run `yay -S doas-keepenv` to install or update

### Nix
1.  Add the _stas-badzi_ channel if you don't have it already: `nix-channel --add https://github.com/stas-badzi/nix-channel/archive/main.tar.gz stasbadzi`
2.  Update channels: `nix-channel --update`
3.  Install program with nix-env: `nix-env -iA stasbadzi.doas-keepenv`

## Packaging

### avilable package fromats
- `.deb` (Debian and derivitives) -> `[root] apt install ./doas-keepenv.deb`
- `.rpm` (RHEL and derivitives) -> `[root] dnf install ./doas-keepenv.rpm`
- `.pkg.tar.`(`zst`/`xz`/`gz`) (Arch Linux and derivitives) -> `[root] pacman -U ./doas-keepenv.pkg.tar.zst`
- `.nar` (Nix package manager) -> `[trusted user] nix-store --import --no-require-sigs < doas-keepenv.nar`
- `.nix` (Nix package manager; Build from source i think) -> `nix-env -if ./doas-keepenv.nix`

### build and install package from source
- `make v=1.0`
- `[root] make install v=1.0` // for nix `make` installs it

### install package
(`su -c`/`doas`/`sudo`) `make install v=1.0`

## Notice
This script changes to /etc/doas.conf while the subprocess is running and it will will be reverted only after the subprocess exits
