-- Remap space as leader key
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " "

vim.g.loaded_matchparen = 0

-- options
-- Search
vim.o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true

vim.o.colorcolumn = "100"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cul = true
vim.o.mouse = "a"
-- Disable horizontal scrolling.
vim.o.mousescroll = 'ver:3,hor:0'

vim.o.signcolumn = "yes"
vim.o.cmdheight = 1
vim.o.updatetime = 200 -- update interval for gitsigns
vim.o.timeoutlen = 400
vim.o.clipboard = "unnamedplus"
vim.o.swapfile = false
vim.o.backup = false
vim.o.pumheight = 30

vim.opt.shortmess:append('c')
vim.opt.completeopt:append {
  'noinsert',
  'menuone',
  'noselect',
  'preview',
  "popup"
}
vim.o.wrap = false
vim.o.scrolloff = 8 -- Make it so there are always lines below my cursor

-- Numbers
vim.wo.number = true -- Make line numbers default
vim.o.numberwidth = 1
-- vim.opt.relativenumber = false

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.inccommand = "split"
vim.o.equalalways = false
vim.o.incsearch = true
vim.o.hlsearch = true

vim.o.showmode = false

vim.opt.diffopt:append {
  'linematch:50',
  'vertical',
  'foldcolumn:0',
  'indent-heuristic',
}

-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")

-- Keep selection when indent/outdent
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

-- OPEN TERMINALS --
vim.keymap.set("n", "<Leader>tv", ":vnew +terminal | setlocal nobuflisted <CR>") -- term over right
vim.keymap.set("n", "<Leader>tx", ":10new +terminal | setlocal nobuflisted <CR>") --  term bottom

-- Tabs
vim.keymap.set("n", "tt", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "tq", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- return normal mode on esc in terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Quickfix list.
vim.keymap.set("n", "<C-j>", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprevious<cr>zz")
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })

-- When toggling, ignore error messages and restore the cursor
-- to the original window when opening the list.
local silent_mods = { mods = { silent = true, emsg_silent = true } }
vim.keymap.set("n", "<C-q>", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose(silent_mods)
  elseif #vim.fn.getqflist() > 0 then
    local win = vim.api.nvim_get_current_win()
    vim.cmd.copen(silent_mods)
    if win ~= vim.api.nvim_get_current_win() then
      vim.cmd.wincmd "p"
    end
  end
end, { desc = "Open quickfix list" })

-- Arrowkeys
vim.keymap.set("", "<up>", "<nop>")
vim.keymap.set("", "<down>", "<nop>")
vim.keymap.set("", "<left>", "<nop>")
vim.keymap.set("", "<right>", "<nop>")

-- horizontal & vertical resize using arrow keys
vim.keymap.set("n", "<up>", ":resize +4<CR>")
vim.keymap.set("n", "<down>", ":resize -4<CR>")
vim.keymap.set("n", "<left>", ":vertical resize -4<CR>")
vim.keymap.set("n", "<right>", ":vertical resize +4<CR>")

-- misc
vim.keymap.set("", "Q", "<Nop>", { silent = true }) -- disable Ex mode
vim.api.nvim_create_user_command("W", ":w", {}) -- map :W to :w

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.o.grepformat = "%f:%l:%c:%m"
else
  local g = "grep --line-number --recursive -I $*"
  vim.o.grepprg = g
  vim.o.grepformat = "%f:%l:%m"
  if vim.fn.has("mac") then
    vim.o.grepprg = g .. " /dev/null"
  end
end

-- diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = false,
  update_in_insert = true,
  severity_sort = true,
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)

-- terminal: disable line numbers and start in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  pattern = "term://*",
  callback = function()
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.scrolloff = 0
    vim.cmd.startinsert()
  end,
})

-- remove buffer on terminal close
vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.cmd.bd()
  end,
})

-- spell check in markdown, and gitcommit file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.cmd.setlocal("spell")
  end,
})

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<Leader>st", function()
  vim.cmd.new()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()

  vim.bo.filetype = "terminal"
end)

vim.api.nvim_set_hl(0, "String", { fg = '#1C7E08' })

local install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(install_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    install_path,
  })
end
vim.opt.rtp:prepend(install_path)

require("lazy").setup("plugins")

-- colorscheme
vim.o.termguicolors = true
vim.cmd("colorscheme grey")

vim.keymap.set("n", "<Leader>g", ":Neogit<CR>")

-- Formatter
vim.keymap.set({ "n", "v" }, "<Leader>fm", function()
  require("conform").format({
    async = true,
    lsp_fallback = true,
  })
end)

vim.keymap.set("n", "<Leader>l", ":lua require('textcase').current_word('to_camel_case')<CR> <CR>")
vim.keymap.set("n", "<Leader>L", ":lua require('textcase').current_word('to_pascal_case')<CR> <CR>")
