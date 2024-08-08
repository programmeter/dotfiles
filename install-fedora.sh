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
sed -i 's/defaultuser/'"$username"'/g' "$script_dir"/sysconfig/lightdm.conf

# Add enpass repository
dnf -y install wget
cd /etc/yum.repos.d/
wget https://yum.enpass.io/enpass-yum.repo
cd -
# Add rpmfusion
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install nvidia drivers
if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	dnf install -y akmod-nvidia nvidia-vaapi-driver libva-utils vdpauinfo
fi
# Install all packages
dnf install -y xinput xcb-util-keysyms lightdm gnome-keyring pipewire pipewire-pulseaudio alsa-utils pavucontrol xfce4-session xfce4-settings qtile python-psutil git vim picom rofi dunst alacritty i3lock xautolock xss-lock firefox steam gimp thunderbird thunar thunar-archive-plugin shotwell celluloid rhythmbox gnome-disk-utility libreoffice-calc libreoffice-writer libreoffice-gtk3 transmission-gtk timeshift galculator mousepad enpass gamemode openvpn openssl openresolv @multimedia playerctl rsync maim xclip gdb unzip htop hplip flatpak SDL2 SDL2-devel SDL2_image SDL2_image-devel SDL2_mixer SDL2_mixer-devel SDL2_ttf SDL2_ttf-devel

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord io.github.shiftey.Desktop org.prismlauncher.PrismLauncher -y

# Copy user configurations
cp -r "$script_dir"/userconfig/.config/ "$home_dir"
cp -r "$script_dir"/userconfig/.local/ "$home_dir"
cp -r "$script_dir"/userconfig/.scripts/ "$home_dir"
cp -r "$script_dir"/userconfig/.bashrc "$script_dir"/userconfig/.vimrc "$home_dir"
mkdir -p "$home_dir"/Pictures/screenshots

# Copy system configurations
cp "$script_dir"/sysconfig/lightdm.conf /etc/lightdm/

# Enable themes for root
ln -s "$home_dir"/.local/share/themes/ /root/.themes
ln -s "$home_dir"/.local/share/icons/ /root/.icons

# Set flatpak theme
flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Yaru-Aqua-dark
flatpak override --env=ICON_THEME=Papirus-Dark

# Delete useless desktop icons
cd /usr/share/applications/
rm -r libreoffice-startcenter.desktop lightdm-settings.desktop panel-desktop-handler.desktop panel-preferences.desktop xfce4-file-manager.desktop xfce4-mail-reader.desktop xfce4-session-logout.desktop xfce4-settings-editor.desktop xfce4-terminal-emulator.desktop xfce4-web-browser.desktop 
cd -

chown -R "$username":"$username" "$home_dir"

systemctl set-default graphical.target
systemctl enable --global pipewire

echo "Copy VPN files to /etc/openvpn"
echo "Set up Timeshift and set rsync destination in ~/.config/qtile/autostart.sh"
echo "Run # hp-setup -i to run HP printer setup"
echo "Tweak settings in xfce settings manager"
echo "Reboot your computer to apply the changes!"
