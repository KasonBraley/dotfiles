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
    i3 rofi light \
    graphviz


# need to handle if already exists
mkdir -p ~/.local/bin

# fd-find symlink
ln -s $(which fdfind) ~/.local/bin/fd

# bat symlink
ln -s /usr/bin/batcat ~/.local/bin/bat

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

# Go benchmark tools
go install golang.org/x/perf/cmd/...@latest

go install fillmore-labs.com/scopeguard@latest

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
