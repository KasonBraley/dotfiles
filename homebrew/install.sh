#!/bin/sh
#
# Homebrew

# install
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# update homebrew recipes
echo "Updating Homebrew recipes..."
brew update

echo "Upgrading Homebrew packages..."
brew upgrade

echo "Install all Homebrew packages..."
brew bundle install --file="~/dotfiles/homebrew/Brewfile"

echo "Cleaning up from Homebrew installations..."
brew cleanup
