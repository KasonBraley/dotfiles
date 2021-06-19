# "Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

#  "hide tab title bars"
defaults write com.googlecode.iterm2 HideTab -bool true

# font setup
defaults write com.googlecode.iterm2 "Normal Font" -string "JetBrains Mono 13";
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "FiraCode Nerd Font Mono 13";

# theme setup
open "./One Dark.itermcolors"
