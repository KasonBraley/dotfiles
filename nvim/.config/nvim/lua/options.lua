local opt = vim.opt
local g = vim.g

opt.ruler = false
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 50 -- update interval for gitsigns
opt.timeoutlen = 400
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.foldlevelstart = 99 -- start unfolded
opt.completeopt = "menu,noselect"
opt.wrap = false
opt.scrolloff = 8 -- Make it so there are always lines below my cursor

opt.grepprg='rg'
opt.grepprg='rg --color=never --no-heading --line-number --column'

-- disable nvim intro
opt.shortmess:append("sI")

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
vim.cmd("let &fcs='eob: '")

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>hl")

g.mapleader = " "

-- colorscheme
opt.termguicolors = true

local function colorscheme()
  vim.cmd([[colorscheme solarized]])
end
pcall(colorscheme)

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- vim-matchup
g.matchup_matchparen_offscreen = {}

-- disable builtin vim plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
