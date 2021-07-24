local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- map navigation between splits using <C-{h,j,k,l}>
map("n", "<C-k>", ":wincmd k<CR>")
map("n", "<C-l>", ":wincmd l<CR>")
map("n", "<C-h>", ":wincmd h<CR>")
map("n", "<C-j>", ":wincmd j<CR>")

-- horizontal & vertical resize
map("n", "+", ":vertical resize +5<CR>", opt)
map("n", "_", ":vertical resize -5<CR>", opt)
map("n", "<leader>=", ":resize +5<CR>", opt)
map("n", "<leader>-", ":resize -5<CR>", opt)

-- OPEN TERMINALS --
map("n", "<C-v>", ":vnew +terminal | setlocal nobuflisted <CR>", opt) -- term over right
map("n", "<C-x>", ":10new +terminal | setlocal nobuflisted <CR>", opt) --  term bottom
map("n", "<C-t>t", ":<Cmd> terminal <CR>", opt) -- term buffer

-- copy whole file content
map("n", "<C-a>", ":%y+<CR>", opt)

-- nvimtree (rest are defaults)
map("n", "<C-n>", ":NvimTreeToggle<CR>", opt)

-- Bufferline tabs
map("n", "<c-t>", ":enew<cr>", opt) -- new buffer
map("n", "tt", ":tabnew<CR>", opt) -- new tab
map("n", "<S-x>", ":Bdelete<CR>", opt) -- close tab
map("n", "<S-x>x", ":Bdelete!<CR>", opt) -- force close tab

-- move between tabs
map("n", "<Tab>", ":BufferLineCycleNext<CR>", opt)
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opt)

-- remove highlighted selection
map("n", "<Esc>", ":noh<CR>", opt)

-- save
map("n", "zs", ":w<CR>", opt)
map("n", "<C-s>", ":w!<CR>", opt)

-- return normal mode on esc in terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Telescope
map("n", "<Leader>gt", ":Telescope git_status <CR>", opt)
map("n", "<Leader>cm", ":Telescope git_commits <CR>", opt)
map("n", "<Leader>ff", ":Telescope find_files <CR>", opt)
map("n", "<Leader>fp", ":Telescope media_files <CR>", opt)
map("n", "<Leader>fb", ":Telescope buffers<CR>", opt)
map("n", "<Leader>fh", ":Telescope help_tags<CR>", opt)
map("n", "<Leader>fo", ":Telescope oldfiles<CR>", opt)
map("n", "<Leader>fw", ":Telescope live_grep<CR>", opt)

-- compe stuff
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif require "luasnip".jumpable(-1) then
    return t "<Plug>luasnip-jump-prev"
  else
    return t "<S-Tab>"
  end
end

function _G.completions()
  local npairs = require("nvim-autopairs")
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"]("<CR>")
    end
  end
  return npairs.check_break_line_char()
end

--  compe mappings
map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("i", "<CR>", "v:lua.completions()", {expr = true})

-- Truezen.nvim
map("n", "<leader>zz", ":TZAtaraxis<CR>", opt)
map("n", "<leader>zm", ":TZMinimalist<CR>", opt)

-- Commenter Keybinding
map("n", "<leader>/", ":CommentToggle<CR>", opt)
map("v", "<leader>/", ":CommentToggle<CR>", opt)

-- Markdown
map("n", "<leader>p", ":MarkdownPreviewToggle <CR>")

-- Hop
map("", "<leader>j", ":HopWord<CR>", opt)
map("", "<leader>l", ":HopLineStart<CR>", opt)
map("", "<leader>s", ":HopPattern<CR>", opt)
map("", "<leader>c", ":HopChar1<CR>", opt)

-- Quickfix
map("", "<C-q>", ":copen<cr>", opt)
map("", "<C-j>", ":cnext<cr>", opt)
map("", "<C-k>", ":cprevious<cr>", opt)

map("", "<leader>q", ":lopen<cr>", opt)
map("", "<leader>n", ":lnext<cr>", opt)
map("", "<leader>k", ":lprevious<cr>", opt)

-- don't be nothered with the type of little window to close, just get rid of it
map("", "cl", ":pclose | lclose | cclose<CR>", opt)

-- format
map("n", "<Leader>fm", ":Format<CR>", opt)

-- map Packer commands since they are not loaded at startup
vim.cmd("silent! command PackerCompile lua require 'pluginList' require('packer').compile()")
vim.cmd("silent! command PackerInstall lua require 'pluginList' require('packer').install()")
vim.cmd("silent! command PackerStatus lua require 'pluginList' require('packer').status()")
vim.cmd("silent! command PackerSync lua require 'pluginList' require('packer').sync()")
vim.cmd("silent! command PackerUpdate lua require 'pluginList' require('packer').update()")
