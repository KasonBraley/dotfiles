# Neovim Key Mappings

### Leader Key
`<space>`

## Commenting
`<leader>` `/` comment line

## Buffers / Tabs / Windows
- `<tab>` next buffer
- `<shift-tab>` previous buffer
- `<shift x>` close buffer
- `<shift x>` `x` force close buffer
- `<leader>` `tt` new tab
- `<leader>` `ta` toggle show all buffers from all tabs
- `<leader>` `tb` bind buffers to tab
- `<leader>` `tc` clear bound buffers to tab
- `<leader>` `tr` rename tab
- `<leader>` `tn` next tab 
- `<leader>` `tp` previous tab

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

## Packer
- `<leader>` `ps` Packer Sync
- `<leader>` `pc` Packer Compile

## Formatter
- `<leader>` `fm` Format entire file

## Neoscroll (smooth scrolling for window movement commands)
- `<C-u>`
- `<C-d>`

## Terminal
- `<C-v>` new terminal on right
- `<C-x>` new terminal on bottom
- `<C-t>` `t` new terminal in a new buffer

## Hop
- `<leader>` `j` Hop word
- `<leader>` `l` Hop line

## Extras
- `<Esc>` remove highlighted selection
- `<leader>` `p` toggle Markdown preview

## Toggles
- `<leader>` `zf` toggle Focus mode (truezen)

## Surround
##### Normal Mode - Sandwhich Mode
- `ys{motion}{char}` **add** surrounding characters
- `sr<from><to>` **replace** surrounding characters
- `sd<char>` **delete** surrounding characters
- `ss` **repeat** last surround command

##### Insert Mode
- `<C-s><char>` Insert both pairs of typed surrounding char
- `<C-s><char><space>` Insert both pairs with surrounding whitespace
- `<C-s><char><C-s>` Insert both pairs on newlines

##### Visual Mode
- `s<char>` Visually select first

##### Extras
- `stq` cycle surrounding quote type
- `stb` cycle surrounding bracket type
- `<char> == f` for adding, replacing, deleting functions

## File Tree (nvim-tree defaults)
- `<Leader>` `pv` toggle Tree
- `g?` toggle Mappings (help)
- `H` toggle hidden files
- `I` Show ignored files
- `<C-v>` open file in vertical split
- `<C-x>` open file in horizontal split
- `<CR>` or `o` or `<2-LeftMouse>` edit
- `<C-t>` tabnew
- `<tab>` preview
- `<C-]>` or `<2-RightMouse>` cd
- `R` refresh
- `a` create
- `d` remove
- `r` rename
- `<C-r>` full rename
- `q` close
- `x` cut
- `p` paste
- `c` copy
- `y` copy name
- `Y` copy path
- `gy` copy absolute path
- `[g` previous git item
- `]g` next git item
- `-` directory up
- `<` previous sibling
- `>` next sibling
- `BS` or `<shift-CR>` close node
