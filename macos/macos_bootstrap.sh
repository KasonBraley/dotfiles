# install Xcode cli tools
#xcode-select --install

# macos setup
echo "Calling macOS specific scripts..."
source ./macos/set-default-settings.sh


# Homebrew setup
echo "Calling homebrew install file..."
source ../homebrew/install.sh


# zsh setup
echo "Calling zsh and oh-my-zsh setu[ scripts..."
source ../zsh/install.sh
