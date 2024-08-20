## Description
This repository contains the config files and scripts for my dwm configuration on Debian. For installation instructions, go to the bottom of this README file - **do NOT run the `install.sh` script!**. The old xmonad and qtile configs are located in the `xmonad-qtile/` directory.
## Screenshots
### Workspace
![Workspace screenshot](screenshots/workspace.png)
## Installation
### Dependencies
Dwm and slstatus build dependencies, alsa utils, i3lock, maim, xclip, alacritty, rofi, picom, dunst, feh, Nordic bluish accent GTK theme (included in `dwm/.local/share/themes/`), papirus nordic dark icon theme (included in `dwm/.local/share/icons`), JetBrains Mono Nerd Font and Ubuntu font (included in `dwm/.local/share/fonts`).

If you are installing the xmonad/qtile configuration, replace the dwm and slstatus dependencies with xmonad, xmonad contrib and xmobar (or qtile). The GTK theme you should use is yaru aqua dark with papirus paleorange icons (not included in the repo). All of the other dependencies listed above apply.
### Installing the theme
**[!] Do not run the `install.sh` script! It is for my personal use only, it installs programs and system configurations that you probably do not need and that could break your system!**

Copy all files from `dwm/` (or `xmonad-qtile`) to your home directory. Be careful to not overwrite your files if you already have files/folders with the same names as the ones in the repo!
