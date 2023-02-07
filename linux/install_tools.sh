#!/usr/bin/env bash
# TODO: make idempotent

set -e
set -x

mkdir -p ~/build

sudo apt update

sudo apt-get install -y \
    build-essential software-properties-common curl \
    git xclip \
    ripgrep pavucontrol fzf zsh \
    net-tools stow jq htop fd-find \
    flameshot bat apt-transport-https \
    i3 rofi light


# need to handle if already exists
mkdir -p ~/.local/bin

# fd-find symlink
ln -s $(which fdfind) ~/.local/bin/fd

# bat symlink
ln -s /usr/bin/batcat ~/.local/bin/bat

# kitty
if ! command -v kitty &> /dev/null ; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    mkdir ~/.local/bin
    # Create a symbolic link to add kitty to PATH (assuming ~/.local/bin is in
    # your system-wide PATH)
    ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty.desktop file(s)
    sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
fi

# neovim
# try this?
# download to /build dir
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# clipboard
curl -sSL https://github.com/Slackadays/Clipboard/raw/main/src/install.sh | bash

# go

# goimports
go install golang.org/x/tools/cmd/goimports@latest

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install node
nvm use latest

# docker
# docker compose

# font
# jetbrains mono

# submodules
cd ~/dotfiles
git submodule init
git submodule update
