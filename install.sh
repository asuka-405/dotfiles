#!/bin/bash
slashes() {
    local term_width=$(tput cols)
    printf '%*s\n' "$term_width" | tr ' ' '/'
}

CURRENT_DIR=$(pwd)

source "$(dirname "$0")/confirm.sh"

echo "installing git"
sudo pacman -S git
slashes

if confirm "installing yay, continue? (y/n)" "installing yay" "continuing without yay" "y/n"; then
	mkdir /home/$USER/.files-repo
	cd /home/$USER/.files-repo
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
    "rofi"
    "rofi-power-menu"
    "tofi"
    "kitty"
    "dolphin"
    "gthumb"
    "firefox"
    "slurp"
    "grim"
)

# Loop through the array and confirm before installing each package
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

echo "Package installation process completed."

if confirm "will remove old hyprland, rofi, tofi and kitty configs, continue now?" "copying" "cannot continue without copying\nmanually copy configs from /home/$USER/.files-repo/dotfiles/config if you want to, exiting!!" "y"; then
	cp -r $CURRENT_DIR/config/* /home/$USER/.config/
else
	exit 1
fi

slashes
echo "enabling screenshotting"
sudo chmod +x /home/$USER/.config/hypr/ss.sh
slashes

echo "done, now logout and login into hyprland,\nto start hyprland,\nchose hyprland in your login manager, or\n if in CLI, type 'hyprland' command to start"
exit 0
