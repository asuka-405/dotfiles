#!/bin/bash
slashes() {
    local term_width=$(tput cols)
    printf '%*s\n' "$term_width" | tr ' ' '/'
}

CURRENT_DIR=$(pwd)
HOME=/home/$USER
SDDM_THEME=

source "$(dirname "$0")/confirm.sh"

slashes
echo "setting up locale"
sudo echo "en_IN UTF-8" > /etc/locale.gen
sudo echo "LANG=en_IN.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc --localtime
locale-gen

slashes
read -p "enter hostname: " hostname
sudo echo "$hostname" > /etc/hostname

slashes
echo "setting up ntp for time"
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd
sudo timedatectl set-ntp true
echo "copying ntp server info to /etc/systemd/timesyncd.conf"
sudo cp $CURRENT_DIR/timesyncd.conf /etc/systemd/
sudo systemctl restart systemd-timesyncd

slashes
echo "installing git"
sudo pacman -S git

slashes
if confirm "installing yay, continue? (y/n)" "installing yay" "continuing without yay" "y/n"; then
	mkdir $HOME/.files-repo
	cd $HOME/.files-repo
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
else
	echo "installation ''will'' fail if yay is not installed"
fi

slashes
echo "installing packages:"

slashes
packages=(
    "hyprland"
    "polkit"
    "gnome-polkit"
    "rofi"
    "rofi-power-menu"
    "tofi"
    "kitty"
    "dolphin"
    "gthumb"
    "firefox"
    "slurp"
    "grim"
    "bluez"
    "bluez-utils"
    "blueman"
    "networkmanager"
    "mpv"
    "mpvpaper"
    "papirus-icon-theme"
    "numix-circle-icon-theme-git"
    "sddm",
    "timeshift",
    "github-cli"
)

for package in "${packages[@]}"; do
    slashes
    if confirm "Do you want to install $package? (y/n)" "Installing $package." "Skipping $package." "y/n"; then
        echo "Installing $package..."
        yay -S --noconfirm "$package"
        if [ $? -ne 0 ]; then
            echo "Failed to install $package."
        else
            echo "$package installed successfully."
        fi
    fi
done

slashes
if confirm "Do you want to install powerlevel10k theme for zsh? (y/n)" "Installing p10k" "Skipping p10k" "y/n"; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
fi

slashes
echo "Package installation process completed."

slashes
if confirm "will remove old hyprland, rofi, tofi and kitty configs, continue now?" "copying" "cannot continue without copying\nmanually copy configs from $HOME/.files-repo/dotfiles/config if you want to, exiting!!" "y"; then
	cp -r $CURRENT_DIR/config/* $HOME/.config/
	cp $CURRENT_DIR/.zshrc $HOME/
else
	exit 1
fi

slashes
echo "installing fonts"
cp -r $CURRENT_DIR/local/* $HOME/.local/
fc-cache -fv

slashes
echo "enabling screenshotting"
sudo chmod +x $HOME/.config/hypr/ss.sh

slashes
echo "enabling NetworkManager"
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

slashes
echo "enabling bluetooth"
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

slashes
echo "enabling sddm"
sudo systemctl enable sddm
sudo systemctl start sddm
#sudo cp -r $CURRENT_DIR/Sweet /usr/share/sddm/themes
#sudo cp $CURRENT_DIR/sddm.conf /etc/

slashes
echo "creating a timeshift snapshot"
timeshift --create --comments "postinstall"

slashes
echo "done,
now logout and login into hyprland,
to start hyprland:
    > chose hyprland in your login manager, or
    > if in CLI, type 'hyprland' command to start
use:
    > 'nmtui' to connect to wifi
    > to connect to bluetooth, bleutooth manager applet in available

check README for more info and keybindings"
exit 0
