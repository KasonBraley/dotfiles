fpath=(~/.config/zsh/kason "${fpath[@]}")

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

# disable CTRL-D closing terminal session
setopt ignoreeof

bindkey -e

# Environment
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

# When deleting with <C-w>, delete file names one at a time.
WORDCHARS=${WORDCHARS/\/}

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
alias gme="git commit --amend -v "${@}""
alias gd="git diff "${@}""
alias g.="git add -p "${@}""
alias gar="git add --all ."
alias gr="git rebase "${@}""
alias gw="git worktree "${@}""
# Like `gw add`, but drops files and directories from the new
# worktree via sparse-checkout so harnesses never loads them and pollutes the context window.
#
# Usage: gwa [-b <branch>] <path> [<commit-ish>]  (same args as `git worktree add`)
_gwa_path() {
  local skip_next=0 arg
  for arg in "$@"; do
    if (( skip_next )); then skip_next=0; continue; fi
    case "$arg" in
      -b|-B|--orphan|--reason) skip_next=1 ;; # flags that consume the next arg
      -*) ;;
      *) print -r -- "$arg"; return ;;       # first positional = worktree path
    esac
  done
}

gwa() {
  git worktree add "$@" || return

  local wt=$(_gwa_path "$@")
  [[ -n "$wt" ]] || return 0
  git -C "$wt" sparse-checkout set --no-cone '/*' '!/.claude/' '!/docs/styles/go/STYLE.md' '!/AGENTS.md' '!/CLAUDE.md' '!/skills'

  # Seed the worktree with the personal AGENTS.override.md (globally gitignored).
  local override="${XDG_CONFIG_HOME:-$HOME/.config}/agents/AGENTS.override.md"
  [[ -f "$override" && ! -e "$wt/AGENTS.override.md" ]] && cp "$override" "$wt/AGENTS.override.md"
}

_gwr_scripts="${XDG_CONFIG_HOME:-$HOME/.config}/rex/scripts"

gwr() {
  gwa "$@" || return

  local wt=$(_gwa_path "$@")
  [[ -n "$wt" ]] || return 0
  wt=${wt:A}

  if [[ -z "$REX_SESSION" ]] || (( ! $+commands[rex] )); then
    print -u2 "gwr: not in a Rex terminal; created $wt without a window"
    return 0
  fi

  local label=$(git -C "$wt" branch --show-current)
  rex do "$_gwr_scripts/worktree-window.lua" \
    --args "$(jq -nc --arg cwd "$wt" --arg label "${label:-${wt:t}}" '{cwd: $cwd, label: $label}')" >/dev/null
}

gwr-rm() {
  local -a flags
  local target="" arg
  for arg in "$@"; do
    case "$arg" in
      -*) flags+=("$arg") ;;
      *) target="$arg" ;;
    esac
  done

  local wt
  wt=$(git -C "${target:-.}" rev-parse --show-toplevel) || return
  wt=${wt:A}
  local main=$(git -C "$wt" worktree list --porcelain | sed -n '1s/^worktree //p')
  if [[ "${main:A}" == "$wt" ]]; then
    print -u2 "gwr-rm: $wt is the main worktree"
    return 1
  fi

  local windows='{}'
  if (( $+commands[rex] )); then
    windows=$(rex do "$_gwr_scripts/worktree-windows.lua" \
      --args "$(jq -nc --arg path "$wt" '{path: $path}')") || return
  fi

  git -C "$main" worktree remove "${flags[@]}" "$wt" || return

  local sid wid
  jq -r '.windows[]? | "\(.session_id) \(.window_id)"' <<< "$windows" | while read -r sid wid; do
    rex api call -s "$sid" session.close_window "$(jq -nc --arg w "$wid" '{window_id: $w}')" >/dev/null
  done
}

gwr-prune() {
  git fetch --all --prune --quiet || return

  local -a gone
  local line wt="" main="" here=""
  git worktree list --porcelain | while IFS= read -r line; do
    case "$line" in
      "worktree "*)
        wt=${line#worktree }
        [[ -n "$main" ]] || main=$wt
        ;;
      "branch "*)
        [[ "$wt" == "$main" ]] && continue
        [[ "$(git for-each-ref --format='%(upstream:track)' "${line#branch }")" == "[gone]" ]] || continue
        if [[ "${PWD:A}/" == "${wt:A}/"* ]]; then here=$wt; else gone+=("$wt"); fi
        ;;
    esac
  done
  [[ -n "$here" ]] && gone+=("$here")

  if (( ! ${#gone} )); then
    print "gwr-prune: no worktrees with a gone upstream"
    return 0
  fi

  print -l "Worktrees whose upstream branch is gone:" "${gone[@]/#/  }"
  read -q "?Remove them and close their Rex windows? [y/N] " || { print; return 1; }
  print

  local -a failed
  for wt in "${gone[@]}"; do
    gwr-rm "$wt" || failed+=("$wt")
  done
  (( ${#failed} )) && print -u2 -l "gwr-prune: kept (see errors above):" "${failed[@]/#/  }"
  return $(( ${#failed} > 0 ))
}
# To clean up and update the local list of remote branches
alias gbc="git remote update origin --prune"
alias gj="git jump"

alias ls='ls -F --color=auto --group-directories-first --sort=version'

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
if type brew &>/dev/null; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Completion
autoload -Uz compinit
compinit
unsetopt auto_remove_slash
zstyle ':completion:*' menu select
zmodload zsh/complist

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --no-ignore'
export FZF_DEFAULT_OPTS='--info=hidden --no-mouse'

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

if [[ $(uname) == "Darwin" ]]; then
    # use GNU utils by default on macos
    export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
fi

alias git_fetch_all='find . -type d -name .git -exec git --git-dir={} --work-tree=$PWD/{}/.. fetch \;'

export PATH="$HOME/dotfiles/bin:$PATH"

export PATH=$PATH:/opt/nvim-macos-arm64/bin
export PATH=$PATH:/opt/nvim-macos/bin

# pnpm
export PNPM_HOME="/Users/kason/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/kason/.bun/_bun" ] && source "/Users/kason/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/Users/kason/.terragrunt/bin:$PATH"
eval "$(~/.local/bin/mise activate zsh)"
