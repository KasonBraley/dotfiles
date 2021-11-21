# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM=~/.config/zsh
ZSH_THEME=common

# installed plugins
plugins=(zsh-autosuggestions vi-mode ripgrep zsh-syntax-highlighting)

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

zstyle ':completion:*' menu select
zmodload zsh/complist

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export TERM="xterm-256color"
export EDITOR='nvim'

# alias
alias m="music"

# git
alias gs="git status -sb"
alias gl="git log --graph --oneline --decorate --all"
alias gql="git log --color --pretty=format:'%Cgreen%h%Creset%C(yellow)%d%Creset %s%Creset' --abbrev-commit -n5"
alias gc="git commit -v"
alias gd="git diff"
alias g.="git add -p"
alias gar="git add --all ."
alias ga="git commit --amend --reuse-message=HEAD"

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh
