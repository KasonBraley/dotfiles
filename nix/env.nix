with import <nixpkgs> {}; [
  air
  bat
# GNU utils
  coreutils-full
  fd
# GNU find utils
  findutils
  fzf
  gdb
  gh
  git
  git-extras
# GNU sed
  gnused
  go
  # godoc ??
  # goimports
  golangci-lint
# GNU grep
  grep
  htop
  jq
  neovim
  nodejs_20
  pprof
  # python
  ripgrep
  ssh-copy-id
  stow
  NIXPKGS_ALLOW_UNFREE=1 terraform
  tree
# benchstat
# govulncheck install with just go install?
# multi-gitter install with just go install?
# pkgsite ??
# zsh-syntax-highlighting
]
