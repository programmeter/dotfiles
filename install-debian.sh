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
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/sysconfig/wakeup-slstatus.service
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/dwm/.config/dwm/config.h
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/dwm/.config/slstatus/config.h
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/dwm/.config/slock/config.h

# Add additional repositories
apt install software-properties-common -y
apt-add-repository non-free -y
apt-add-repository contrib -y
dpkg --add-architecture i386

# Get Enpass repo key
echo "deb https://apt.enpass.io/ stable main" > \
  /etc/apt/sources.list.d/enpass.list
wget -O - https://apt.enpass.io/keys/enpass-linux.key | tee /etc/apt/trusted.gpg.d/enpass.asc
apt update

# Download necessary .debs
wget https://launcher.mojang.com/download/Minecraft.deb

# Install nvidia drivers
if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	apt install nvidia-driver nvidia-settings nvidia-driver-libs:i386 -y
fi
# Install all packages
apt install xorg make gcc libx11-dev libxft-dev libxinerama-dev libimlib2-dev libxcb-keysyms1 pipewire pipewire-pulse pipewire-alsa alsa-utils xss-lock steam gimp inkscape xfce4-settings thunderbird firefox-esr alacritty thunar vim git unzip shotwell celluloid rofi lightdm feh picom dunst xinput maim xclip libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev rhythmbox xautolock htop libavcodec-extra playerctl gnome-disk-utility gufw enpass libreoffice-calc libreoffice-writer libreoffice-gtk3 printer-driver-hpcups hplip gamemode openvpn openssl openresolv transmission-gtk rsync timeshift pavucontrol gdb flatpak galculator mousepad thunar-archive-plugin python3-venv ./Minecraft.deb -y
apt install --no-install-recommends xfce4-session -y

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mkdir -p /opt/nvim
mv nvim.appimage /opt/nvim/nvim

# Install flatpaks
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord io.github.shiftey.Desktop -y

# Install dwm, slstatus, slock
cd "$script_dir"/dwm/.config/dwm
make clean install
cd -
cd "$script_dir"/dwm/.config/slstatus
make clean install
cd -
cd "$script_dir"/dwm/.config/slock
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
cp "$script_dir"/sysconfig/wakeup-slstatus.service /etc/systemd/system

rm /usr/share/xsessions/xfce.desktop

# Fix slstatus sleep bug
systemctl enable wakeup-slstatus

# Enable themes for root
ln -s "$home_dir"/.local/share/themes/ /root/.themes
ln -s "$home_dir"/.local/share/icons/ /root/.icons

# Set flatpak theme
flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Nordic-bluish-accent
flatpak override --env=ICON_THEME=Papirus-Dark

chown -R "$username":"$username" "$home_dir"

echo "Copy VPN files to /etc/openvpn"
echo "Set up Timeshift and set rsync command in ~/.scripts/rsync-home.sh"
echo "Run # hp-setup -i to run HP printer setup"
echo "Add @reboot sleep 10 && /usr/bin/apt-get update to sudo crontab -e"
echo "Tweak settings in xfce settings manager"
echo "Reboot your computer to apply the changes!"
