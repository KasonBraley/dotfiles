fpath=(~/.config/zsh/kason "${fpath[@]}")
autoload -Uk ls
autoload -Uk deduplicate_history_lines
autoload -Uk search_history

#history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_find_no_dups
setopt inc_append_history
unsetopt hist_ignore_space

# Command interpretation.
setopt autocd
setopt chase_dots
setopt interactive_comments

bindkey -e

# Completion
autoload -Uz compinit
compinit
unsetopt auto_remove_slash
zstyle ':completion:*' menu select
zmodload zsh/complist

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Environment
export TERM="xterm-256color"
export EDITOR='nvim'

# Prompt
prompt_cwd() {
    prompt_shrink_path "$(print -P %~)"
}

# Replace /foo/bar/baz with /f/b/baz.
prompt_shrink_path() {
    local path="${1}"
    setopt local_options
    setopt extended_glob
    printf %s "${path//(#b)([^\/])[^\/]#\//${match[1]}/}"
}

setopt prompt_subst
PROMPT=
# Current directory.
PROMPT="${PROMPT}%F{green}\$(prompt_cwd)%f"
# Exit code of previous command.
PROMPT="${PROMPT}%(0?;; %F{red}%?%f)"
# Terminator.
PROMPT="${PROMPT}> "

# git branch display
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{green}%b%f'
zstyle ':vcs_info:*' enable git

# git
alias gs="git status -sb "${@}" && { gql 2>/dev/null || : }"
alias gl="git log --graph --oneline --decorate"
alias gql="git log --color --pretty=format:'%Cgreen%h%Creset%C(yellow)%d%Creset %s%Creset' --abbrev-commit -n5"
alias gc="git commit -v "${@}""
alias ga="git commit --amend --reuse-message=HEAD"
alias gd="git diff "${@}""
alias g.="git add -p "${@}""
alias gar="git add --all ."
alias gr="git rebase "${@}""

# Search through history of typed word
# arrow keys
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey "^P" history-search-backward
bindkey "^N" history-search-forward

# ctrl + left/right arrow to move between words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Input styling
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
typeset -A ZSH_HIGHLIGHT_STYLES

_command_style='fg=green'
_argument_style='fg=39'
_error_style='fg=red'
ZSH_HIGHLIGHT_STYLES[alias]="${_command_style}"
ZSH_HIGHLIGHT_STYLES[arg0]="${_command_style}"
ZSH_HIGHLIGHT_STYLES[builtin]="${_command_style}"
ZSH_HIGHLIGHT_STYLES[command]="${_command_style},underline"
ZSH_HIGHLIGHT_STYLES[comment]='fg=10'
ZSH_HIGHLIGHT_STYLES[default]="${_argument_style}"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]="${_error_style}"
ZSH_HIGHLIGHT_STYLES[double-hypen-option]="${_argument_style}"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="${_error_style}"
ZSH_HIGHLIGHT_STYLES[function]="${_command_style}"
ZSH_HIGHLIGHT_STYLES[hashed-command]="${_command_style},underline"
ZSH_HIGHLIGHT_STYLES[path]="${_argument_style},underline"
ZSH_HIGHLIGHT_STYLES[precommand]="${_command_style}"
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=093'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="${_argument_style}"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="${_error_style}"

# auto completion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/.nvm/nvm.sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --no-ignore'
export FZF_DEFAULT_OPTS='--info=hidden --no-mouse'

zle -N search_history
bindkey '^R' search_history

# colorized go test output
set -o pipefail
alias got='go test -v -cover -race ./... | sed ''/PASS/s//$(printf "\033[32mPASS\033[0m")/'' | sed ''/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'''

alias rg="
rg --colors line:fg:yellow      \
   --colors line:style:bold     \
   --colors path:fg:green       \
   --colors path:style:bold     \
   --colors match:fg:black      \
   --colors match:bg:yellow     \
   --colors match:style:nobold  \
"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
