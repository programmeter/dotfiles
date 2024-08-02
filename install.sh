#!/bin/bash

# THIS SCRIPT IS NOT JUST FOR INSTALLING MY XMONAD THEME!!!
# IT ALSO INSTALLS PACKAGES WHICH YOU PROBABLY DON'T NEED,
# AND THEY MIGHT EVEN BREAK YOUR SYSTEM
# IT IS FOR MY PERSONAL USE ONLY
# DO NOT RUN THIS SCRIPT

# Set up variables
read -p "[!] Enter username: " username
read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
while [[ "$nvidia_prompt" != "y" && "$nvidia_prompt" != "Y" && "$nvidia_prompt" != "n" && "$nvidia_prompt" != "y" && "$nvidia_prompt" != "N" ]]
do	
	echo "Please select y/n"
	read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
done
home_dir='/home/'"$username"
script_dir=$(dirname $(realpath $0))

# Set username
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/userconfig/xmobarrc
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/sysconfig/lightdm.conf
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/sysconfig/xmonad.desktop

# Add additional repositories
xbps-install void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree -y
xbps-install -S

# Install nvidia drivers
if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	xbps-install nvidia nvidia-libs-32bit -y
    # Enable nvidia runit service
    ln -s /etc/sv/nvidia-powerd/ /var/service/
fi
# Install all packages
xbps-install xorg lightdm elogind \
    pipewire alsa-pipewire wireplumber-elogind dbus-elogind alsa-utils pavucontrol \
    xfce4-session xfce-polkit xfce4-settings \
    ncurses-libtinfo-libs ncurses-libtinfo-devel libX11-devel libXft-devel libXinerama-devel libXrandr-devel libXScrnSaver-devel pkg-config cabal-install \
    git vim picom rofi xmobar dunst alacritty feh \
    libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit \
    i3lock xautolock xss-lock \
    firefox steam gimp thunderbird Thunar thunar-archive-plugin shotwell celluloid rhythmbox gnome-disk-utility libreoffice-calc libreoffice-writer libreoffice-gnome transmission-gtk timeshift galculator mousepad PrismLauncher keepassxc
    gamemode openvpn openssl openresolv libavcodec playerctl rsync maim xclip gdb unzip htop hplip \
    flatpak \
    SDL2 SDL2-devel SDL2_image SDL2_image-devel SDL2_mixer SDL2_mixer-devel SDL2_ttf SDL2_ttf-devel -y 
# Install xmonad
mkdir -p "$home_dir"/.config/xmonad/
cp "$script_dir"/userconfig/.config/xmonad/xmonad.hs "$home_dir"/.config/xmonad/
sudo -u "$username" cabal update
sudo -u "$username" cabal install --package-env="$home_dir"/.config/xmonad --lib base xmonad xmonad-contrib
sudo -u "$username" cabal install --package-env="$home_dir"/.config/xmonad xmonad

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord io.github.shiftey.Desktop -y

# Enable runit services
ln -s /etc/sv/lightdm/ /var/service/
ln -s /etc/sv/dbus /var/service
ln -s /etc/sv/polkitd/ /var/service/

# Set up pipewire
mkdir -p /etc/pipewire/pipewire.conf.d
mkdir -p /etc/alsa/conf.d
ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

# Copy user configurations
cp -r "$script_dir"/userconfig/.config/ "$home_dir"
cp -r "$script_dir"/userconfig/.local/ "$home_dir"
cp -r "$script_dir"/userconfig/.scripts/ "$home_dir"
cp -r "$script_dir"/userconfig/.bashrc "$script_dir"/userconfig/.vimrc "$home_dir"
mkdir -p "$home_dir"/Pictures/screenshots

# Copy system configurations
cp "$script_dir"/sysconfig/lightdm.conf /etc/lightdm/
cp "$script_dir"/sysconfig/xmonad.desktop /usr/share/xsessions/

# Enable themes for root
ln -s ~/.local/share/themes/ /root/.themes
ln -s ~/.local/share/icons/ /root/.icons

# Set flatpak theme
flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Yaru-Aqua-dark
flatpak override --env=ICON_THEME=Papirus-Dark

# Set theme with xfce settings
xfconf-query -c xsettings -p /Net/ThemeName -s "Yaru-Aqua-dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"

# Delete useless desktop icons
rm -r compton.desktop libreoffice-startcenter.desktop mpv.desktop picom.desktop rofi-theme-selector.desktop xfce4-about.desktop xfce4-file-manager.desktop xfce4-mail-reader.desktop xfce4-session-logout.desktop  xfce4-settings-editor.desktop xfce4-terminal-emulator.desktop xfce4-web-browser.desktop

chown -R "$username":"$username" "$home_dir"

xdg-settings set default-web-browser firefox.desktop
xdg-mime default thunar.desktop inode/directory

echo "Copy VPN files to /etc/openvpn"
echo "Set up Timeshift and set rsync destination in ~/.config/xmonad/xmonad.hs"
echo "Run # hp-setup -i to run HP printer setup"
echo "Reboot your computer to apply the changes!"
