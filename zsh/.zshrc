# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=common

# installed plugins
<<<<<<< HEAD:zsh/.zshrc
plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting vi-mode osx ripgrep)
=======
plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting vi-mode npm osx fd gh ripgrep tmux tmuxinator)

>>>>>>> 77e10a4 (Delete dotbot; Use stow):zsh/zshrc

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

source $ZSH/oh-my-zsh.sh
