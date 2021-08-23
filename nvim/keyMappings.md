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
- `<Leader>` `.a` code action
- `<Leader>` `.;` show line diagnostics
- `.l` move to next diagnostic

## File Tree (nvim-tree defaults)
- `<C-a` toggle Tree
- `g?` toggle Mappings (help)

## Telescope
- `<leader>` `ff` find files in current Directory
- `<C-h>` git files
- `<leader>` `fi` current buffer fuzzy find
- `<leader>` `fp` media files
- `<leader>` `fb` open buffers
- `<leader>` `fh` help tags
- `<leader>` `fo` open recently edited files
- `<leader>` `fw` live grep
- `<leader>` `ft` telescope file browser
- `<leader>` `fd` custom search `dev` folder
- `<leader>` `fc` custom search `dotfiles` folder
- `<leader>` `fB` builtins
- `<leader>` `fs` treesitter symbols
- `<leader>` `pw` grep the hovered word in the cwd
- `<leader>` `ps` grep for word input
- `<C-v>` open files in vertical split
- `<C-x>` open files in horizontal split

## Git
- `<leader>` `g` Neogit open
- `<leader>` `gc` Neogit commit
- `<leader>` `gs` git status
- `<leader>` `gB` git branches
- `<leader>` `gl` git commits

## Harpoon
- `<C-f>` Harpoon ui toogle
- `<leader>` `a` Harpoon mark file
- `<C-j>` Harpoon go to file 1
- `<C-k>` Harpoon go to file 2
- `<C-l>` Harpoon go to file 3
- `<C-h>` Harpoon go to file 4
- `<leader>` `kf` Harpoon go to terminal 1
- `<leader>` `kd` Harpoon got to terminal 2

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
