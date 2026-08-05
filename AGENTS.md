# Working in this repository

This is a personal dotfiles repository. Prefer small, targeted changes that preserve the existing workflow and conventions over broad cleanup.

## Layout

- Each top-level application directory is a GNU Stow package. Its contents mirror paths below `$HOME`; for example, `nvim/.config/nvim/init.lua` installs as `~/.config/nvim/init.lua`.
- `install.sh` is the common installer. Platform provisioning lives under `macos/`, `linux/`, and `nix/` and is run separately.
- `.agents/skills/` is the canonical skill tree. `.claude/skills/` and `.pi/skills/` are consumer-specific symlink mirrors. When changing installed skills, keep the skill tree, mirrors, and `skills-lock.json` consistent rather than copying divergent versions.

## Changes

1. Inspect `git status` before editing and preserve unrelated local changes.
2. Edit the package source in this repository, not the stowed file under `$HOME`.
3. Follow the style of the file being changed. Neovim Lua follows `nvim/.config/nvim/.editorconfig`.
4. Add a package to `install.sh` only when it should be installed by the common setup path; keep platform-specific setup in its platform directory.
5. Keep machine- and user-specific values intentional. Store configuration and public-key paths here, but keep credentials, tokens, and private keys out of the repository.

## Validation

There is no repository-wide test suite. Run the narrowest checks that cover every changed file:

- Shell scripts: `bash -n <files>`
- Zsh configuration: `zsh -n zsh/.zshrc`
- Lua files: `luac -p <files>` when `luac` is available
- Stow layout: `stow --no --verbose --target "$HOME" <package>`

Treat bootstrap and provisioning scripts as destructive: syntax-check them and inspect their diff unless the user explicitly asks to execute them. Report checks that could not run because a tool is unavailable.
