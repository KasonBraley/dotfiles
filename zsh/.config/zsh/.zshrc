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

pb-kill-line () {
  zle kill-line   # `kill-line` is the default ctrl+k binding
  echo -n $CUTBUFFER | xsel -ib
}

pb-kill-whole-line () {
  zle kill-whole-line
  echo -n $CUTBUFFER | xsel -ib 
}

zle -N pb-kill-line  # register our new function
zle -N pb-kill-whole-line  # register our new function

bindkey '^K' pb-kill-line  # change the ctrl+k binding to use our new function
bindkey '^U' pb-kill-whole-line  # change the ctrl+u binding to use our new function

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
