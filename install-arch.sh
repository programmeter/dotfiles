#!/bin/bash

# THIS SCRIPT IS NOT JUST FOR INSTALLING MY WM THEME!!!
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
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/sysconfig/lightdm.conf
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/dwm/.config/dwm/config.h
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/dwm/.config/slstatus/config.h

# Install nvidia drivers
if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	pacman -S nvidia-open-dkms nvidia-settings nvidia-utils lib32-nvidia-utils --noconfirm
fi
# Install all packages
pacman -S xorg-server make gcc libx11 libxft libxinerama pipewire pipewire-pulse man-db pipewire-alsa alsa-utils i3lock steam gimp xfce4-settings xfce4-session gnome-keyring thunderbird firefox alacritty thunar vim git unzip shotwell celluloid rofi lightdm lightdm-gtk-greeter feh picom dunst maim xclip sdl2 sdl2_image sdl2_ttf sdl2_mixer rhythmbox xautolock xss-lock htop playerctl gnome-disk-utility libreoffice-still hplip gamemode openvpn openssl openresolv transmission-gtk rsync timeshift pavucontrol gdb flatpak galculator mousepad thunar-archive-plugin neovim keepassxc --noconfirm

# Install flatpaks
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord io.github.shiftey.Desktop org.prismlauncher.PrismLauncher -y

# Install dwm and slstatus
cd "$script_dir"/dwm/.config/dwm
make clean install
cd -
cd "$script_dir"/dwm/.config/slstatus
make clean install
cd -

# Copy user configurations
cp -r "$script_dir"/dwm/.config/ "$home_dir"
cp -r "$script_dir"/dwm/.local/ "$home_dir"
cp -r "$script_dir"/dwm/.scripts/ "$home_dir"
cp -r "$script_dir"/dwm/.bashrc "$script_dir"/dwm/.vimrc "$script_dir"/dwm/.Xresources "$home_dir"
mkdir -p "$home_dir"/Pictures/screenshots

# Copy system configurations
cp "$script_dir"/sysconfig/lightdm.conf /etc/lightdm/
cp "$script_dir"/sysconfig/dwm.desktop /usr/share/xsessions
rm /usr/share/xsessions/xfce.desktop

# Remove unnecesasry desktop files
cd /usr/share/applications
rm -r avahi-discover.desktop bssh.desktop bvnc.desktop compton.desktop picom.desktop feh.desktop hplip.desktop hp-uiscan.desktop mpv.desktop libreoffice-base.desktop libreoffice-draw.desktop libreoffice-impress.desktop libreoffice-math.desktop libreoffice-startcenter.desktop libreoffice-xsltfilter.desktop qv4l2.desktop qvidcap.desktop rofi-theme-selector.desktop xfce4-about.desktop xfce4-accessibility-settings.desktop xfce4-file-manager.desktop xfce4-mail-reader.desktop xfce4-session-logout.desktop xfce4-settings-editor.desktop xfce4-terminal-emulator.desktop xfce4-web-browser.desktop
cd -

# Enable themes for root
ln -s "$home_dir"/.local/share/themes/ /root/.themes
ln -s "$home_dir"/.local/share/icons/ /root/.icons

# Set flatpak theme
flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Nordic-bluish-accent
flatpak override --env=ICON_THEME=Papirus-Dark

# Enable lightdm
systemctl enable lightdm

chown -R "$username":"$username" "$home_dir"

echo "Copy VPN files to /etc/openvpn"
echo "Set up Timeshift and set rsync destination in WM autostart script"
echo "Run # hp-setup -i to run HP printer setup"
echo "Tweak settings in xfce settings manager"
echo "Reboot your computer to apply the changes!"
