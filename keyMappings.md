# Neovim Key Mappings

### Leader Key
`<space>`

## Commenting
`<leader />`

## Tabs
- `<tab>`
- `<shift-tab>`

## Navigation between splits
- `<C-k>` up
- `<C-l>` right
- `<C-h>` left
- `<C-j>` down

## File Tree (nvim-tree)
- `<C-n>` toggle Tree
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

## LSP
- `gD`
- `gd`
- `K`
- `gi`
- `<C-k>`
- `<space wa>`
- `<space wr>`
- `<space wl>`
- `<space D>`
- `<space rn>`
- `gr`
- `<space e>`
- `[d`
- `]d`
- `<space q>`

## Toggles
- `<leader>` `n` toggle line numbers
- `<leader>` `z` toggle Zen mode (truezen)
- `<leader>` `m` toggle Minimalist mode (truezen)

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

## Telescope
- `<leader>` `fb` open all buffers
- `<leader>` `ff` find files in current Directory
- `<leader>` `fo` open recently edited files
- `<leader>` `fh` open up a help page
- `<C-v>` open files in vertical split
- `<C-x>` open files in horizontal split

## Formatter
- `<leader-fm>` Format entire file
TODO - `<leader-f` Format selected section

## Neoscroll (smooth scrolling for window movement commands)
- `<C-u>`
- `<C-d>`
- `<C-b>`
- `<C-f>`
- `<C-y>`
- `<C-e>`

## Terminal
- `<C-v>` new terminal on right
- `<C-x>` new terminal on bottom
- `<C-t>` `t` new terminal in a new tab

## Buffers / Windows / tabs / Panes
## Resize (Normal Mode)
- `+` resize vertical +5
- `_` resize vertical -5
- `<leader>` `=` resize horizontal +5
- `<leader>` `-` resize horizontal +5

## Git
- `<leader>` `lg` toggle LazyGit plugin

## Extras
- `<leader>` `<Esc>` remove highlighted selection
- `<leader>` `p` toggle Glow plugin for Markdown preview
- ``
