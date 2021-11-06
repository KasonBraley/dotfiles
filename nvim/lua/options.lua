local opt = vim.opt
local g = vim.g

opt.ruler = false
opt.hidden = true
opt.ignorecase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.cul = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.updatetime = 50 -- update interval for gitsigns
opt.timeoutlen = 400
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.wildmenu = true
opt.foldlevelstart = 99 -- start unfolded
opt.completeopt = "menu,noselect"

-- disable nvim intro
opt.shortmess:append "sI"

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
vim.cmd "let &fcs='eob: '"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true

-- Indenline
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>hl"

g.mapleader = " "

g.dap_virtual_text = true

-- tokyonight theme
vim.cmd [[colorscheme tokyonight]]

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

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
