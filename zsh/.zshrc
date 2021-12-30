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
# zstyle ':vcs_info:git:*' formats '%F{240}%b%f'
zstyle ':vcs_info:*' enable git

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
alias ga="git commit --amend --reuse-message=HEAD"
alias gd="git diff"
alias g.="git add -p"
alias gar="git add --all ."
alias gr="git rebase"

# Search through history of typed word
# arrow keys
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# ctrl + left/right arrow to move between words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Input styling
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
typeset -A ZSH_HIGHLIGHT_STYLES

_command_style='fg=26'
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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=238'
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --no-ignore'
export FZF_DEFAULT_OPTS='--info=hidden --no-mouse'

deduplicate_history_lines() {
    perl -e '
        use 5.010;
        use autodie;
        use strict;
        use warnings;

        my %seen_commands;
        while (<>) {
            if (/^\s*\d+[ *](.*)\n?$/) {
                if (!$seen_commands{$1}) {
                    print $_;
                    $seen_commands{$1} = 1;
                }
            } elsif (!/^\n?$/) {
                say STDERR "warning: failed to parse history line: $_";
            }
        }
    '
}

search_history() {
    local selection_fields=($( \
        fc -l -r 1 \
        | deduplicate_history_lines \
        | fzf \
            ${=FZF_DEFAULT_OPTS} \
            --delimiter='  ' \
            "--query=${BUFFER}" \
            --tiebreak=index \
            --with-nth=2..
    ))
    if [ "${#selection_fields[@]:-}" -ne 0 ]; then
        local history_index="${selection_fields[1]}"
        zle vi-fetch-history -n "${history_index}"
    fi
}

zle -N search_history
bindkey '^R' search_history
