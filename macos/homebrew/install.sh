#!/usr/bin/env bash

brew analytics off

# update homebrew recipes
echo "Updating Homebrew recipes..."
brew update

echo "Upgrading Homebrew packages..."
brew upgrade

echo "Install all Homebrew packages..."
brew bundle install --file="./Brewfile"

echo "Cleaning up from Homebrew installations..."
brew cleanup
