# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM=~/.config/zsh
ZSH_THEME=common

# installed plugins
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

zstyle ':completion:*' menu select
zmodload zsh/complist

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
alias gr="git rebase"

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh
