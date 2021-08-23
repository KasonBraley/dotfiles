# Neovim Key Mappings

### Leader Key
`<space>`

## Commenting
`<leader>` `/` comment line

## Buffers / Tabs / Windows
- `<leader><leader>` last buffer
- `<shift x>` close buffer
- `<shift x>` `x` force close buffer
- `<leader>` `tt` new tab
- `<leader>` `tn` next tab 
- `<leader>` `tp` previous tab
- `<leader>` `tc` close tab

#### Resize (Normal Mode)
- `<up>` resize vertical +2
- `<down>` resize vertical -2
- `<left>` resize horizontal +2
- `<right>` resize horizontal -2

## LSP
- `gh` lsp finder
- `gd` preview definition
- `K` hover info
- `<C-s>` displays signature information
- `<Leader>` `rn` rename
- `<Leader>` `ca` code action
- `<Leader>` `cl` show line diagnostics
- `<Leader>` `cc` show cursor diagnostics
- `[d` move to next diagnostic
- `]d` move to previous diagnostic

## Telescope
- `<leader>` `ff` find files in current Directory
- `<leader>` `fi` current buffer fuzzy find
- `<leader>` `fp` media files
- `<leader>` `fb` open buffers
- `<leader>` `fh` help tags
- `<leader>` `fo` open recently edited files
- `<leader>` `fw` live grep
- `<leader>` `ft` telescope file browser
- `<leader>` `fd` custom search `dev` folder
- `<leader>` `fc` custome search `dotfiles` folder
- `<leader>` `fB` builtins
- `<leader>` `fs` treesitter symbols
- `<leader>` `pw` grep the hovered word in the cwd
- `<leader>` `gt` git status
- `<leader>` `gb` git current buffer commits
- `<leader>` `gB` git branches
- `<leader>` `gc` git commits
- `<C-v>` open files in vertical split
- `<C-x>` open files in horizontal split

## DAP
- `<leader>` `dc` start/continue
- `<leader>` `do` step over
- `<leader>` `di` step into
- `<leader>` `dx` step out
- `<leader>` `db` toggle breakpoint
- `<leader>` `dB` toggle breakpoint with condition
- `<leader>` `dp` toggle breakpoint with log message
- `<leader>` `dr` open repl
- `<leader>` `dl` run last
- `<leader>` `du` toggle dapui
- `<leader>` `de` dapui evaluate expression

## Refactor
- `<leader>` `rr` Refactor telescope ui open
- `<leader>` `re` Refactor extract function
- `<leader>` `rf` Refactor extract function to file

## Formatter
- `<leader>` `fm` Format entire file

## Neoscroll (smooth scrolling for window movement commands)
- `<C-u>`
- `<C-d>`

## Terminal
- `<C-v>` new terminal on right
- `<C-x>` new terminal on bottom

## Extras
- `<Esc>` remove highlighted selection
- `<leader>` `p` toggle Markdown preview
- `<leader>` `cd` set current working directory to match current buffer working directory
