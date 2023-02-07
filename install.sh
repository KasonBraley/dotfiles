#!/usr/bin/env bash

if ! command -v stow &> /dev/null; then
    echo "stow is not installed, have you ran install_tools.sh?"
    exit
fi 

stow --target "$HOME" git
stow --target "$HOME" i3
stow --target "$HOME" kitty
stow --target "$HOME" nvim
stow --target "$HOME" zsh
