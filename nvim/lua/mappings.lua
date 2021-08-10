local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
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

-- Commenter Keybinding
vim.api.nvim_set_keymap("n", "<leader>/", "<Plug>kommentary_line_default", {})
-- vim.api.nvim_set_keymap("n", "<leader>c", "<Plug>kommentary_motion_default", {})
vim.api.nvim_set_keymap("x", "<leader>/", "<Plug>kommentary_visual_default<C-c>", {})

-- format
map("n", "<Leader>fm", ":Format<CR>", opt)

-- OPEN TERMINALS --
map("n", "<C-v>", ":vnew +terminal | setlocal nobuflisted <CR>", opt) -- term over right
map("n", "<C-x>", ":10new +terminal | setlocal nobuflisted <CR>", opt) --  term bottom
map("n", "<C-t>t", ":<Cmd> terminal <CR>", opt) -- term buffer

-- copy whole file content
map("n", "<C-a>", ":%y+<CR>", opt)

-- nvimtree (rest are defaults)
map("n", "<Leader>pv", ":NvimTreeToggle<CR>", opt)

-- Bufferline tabs
map("n", "<C-t>", ":enew<cr>", opt) -- new buffer
map("n", "tt", ":tabnew<CR>", opt) -- new tab
map("n", "<S-x>", ":Bdelete<CR>", opt) -- close tab
map("n", "<S-x>x", ":Bdelete!<CR>", opt) -- force close tab

-- move between tabs
map("n", "<Tab>", ":BufferLineCycleNext<CR>", opt)
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opt)

-- remove highlighted selection
map("n", "<Esc>", ":noh<CR>", opt)

-- save
map("n", "zs", ":w!<CR>", opt)

-- return normal mode on esc in terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Telescope
map("n", "<Leader>gt", ":Telescope git_status <CR>", opt)
map("n", "<Leader>gB", ":Telescope git_branches <CR>", opt)
map("n", "<Leader>gb", ":Telescope git_bcommits <Cr>", opt)
map("n", "<Leader>gc", ":Telescope git_commits <CR>", opt)
map("n", "<Leader>ff", ":Telescope find_files <CR>", opt)
map("n", "<Leader>fi", ":Telescope current_buffer_fuzzy_find <CR>", opt)
map("n", "<Leader>fp", ":Telescope media_files <CR>", opt)
map("n", "<Leader>fb", ":Telescope buffers<CR>", opt)
map("n", "<Leader>fh", ":Telescope help_tags<CR>", opt)
map("n", "<Leader>fo", ":Telescope oldfiles<CR>", opt)
map("n", "<Leader>fw", ":Telescope live_grep<CR>", opt)
map("n", "<Leader>ft", ":Telescope file_browser<CR>", opt)
map("n", "<Leader>fd", ":lua require('plugins.others').search_dev()<CR>", opt)
map("n", "<Leader>fc", ":lua require('plugins.others').search_dotfiles()<CR>", opt)
map("n", "<leader>pw", ":lua require('telescope.builtin').grep_string {search = vim.fn.expand('<cword>')}<CR>", opt)
map("n", "<leader>fB", ":Telescope builtin <CR>", opt)
map("n", "<leader>fs", ":Telescope treesitter <CR>", opt)

-- compe stuff
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
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
  elseif require("luasnip").jumpable(-1) then
    return t "<Plug>luasnip-jump-prev"
  else
    return t "<S-Tab>"
  end
end

function _G.completions()
  local npairs = require "nvim-autopairs"
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"] "<CR>"
    end
  end
  return npairs.check_break_line_char()
end

--  compe mappings
map("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
map("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
map("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
map("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
map("i", "<CR>", "v:lua.completions()", { expr = true })

-- Truezen.nvim
map("n", "<leader>zz", ":TZAtaraxis<CR>", opt)
map("n", "<leader>zm", ":TZMinimalist<CR>", opt)

-- Markdown
map("n", "<leader>p", ":MarkdownPreviewToggle <CR>")

-- Hop
map("", "<leader>j", ":HopWord<CR>", opt)
map("", "<leader>l", ":HopLineStart<CR>", opt)

-- Quickfix
map("", "<C-q>", ":copen<cr>", opt)
map("", "<C-j>", ":cnext<cr>", opt)
map("", "<C-k>", ":cprevious<cr>", opt)

map("", "<leader>q", ":lopen<cr>", opt)
map("", "<leader>n", ":lnext<cr>", opt)
map("", "<leader>k", ":lprevious<cr>", opt)

-- don't be nothered with the type of little window to close, just get rid of it
map("", "cl", ":pclose | lclose | cclose<CR>", opt)

-- lspsaga
map("n", "gh", ":Lspsaga lsp_finder<CR>", opt)
map("n", "<leader>ca", ":Lspsaga code_action<CR>", opt)
map("v", "<leader>ca", ":Lspsaga range_code_action<CR>", opt)
map("n", "K", ":Lspsaga hover_doc<CR>", opt)
map("n", "gs", ":Lspsaga signature_help<CR>", opt)
map("n", "rn", ":Lspsaga rename<CR>", opt)
map("n", "gd", ":Lspsaga preview_definition<CR>", opt)
map("n", "<leader>cd", ":Lspsaga show_line_diagnostics<CR>", opt)
map("n", "<leader>cc", ":Lspsaga show_cursor_diagnostics<CR>", opt)
map("n", "[e", ":Lspsaga diagnostic_jump_next<CR>", opt)
map("n", "]e", ":Lspsaga diagnositic_jump_prev<CR>", opt)
map("n", "<A-d>", ":Lspsaga open_floaterm", opt)
map("t", "<A-d> <C-\\><C-n>", ":Lspsaga close_floaterm<CR>", opt)

-- DAP
map("n", "<leader>dc", ":lua require'dap'.continue()<CR>", opt)
map("n", "<leader>do", ":lua require'dap'.step_over()<CR>", opt)
map("n", "<leader>di", ":lua require'dap'.step_into()<CR>", opt)
map("n", "<leader>dx", ":lua require'dap'.step_out()<CR>", opt)
map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opt)
map("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opt)
map("n", "<leader>dp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opt)
map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", opt)
map("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", opt)
map("n", "<leader>du", ":lua require'dapui'.toggle()<CR>")
map("n", "<leader>de", ":lua require'dapui'.eval()<CR>")
map("v", "<leader>de", ":lua require'dapui'.eval()<CR>")

map("", "Y", "y$", opt)

-- Arrowkeys
map("", "<up>", "<nop>", opt)
map("", "<down>", "<nop>", opt)
map("", "<left>", "<nop>", opt)
map("", "<right>", "<nop>", opt)

-- horizontal & vertical resize using arrow keys
map("n", "<up>", ":resize +2<CR>", opt)
map("n", "<down>", ":resize -2<CR>", opt)
map("n", "<left>", ":vertical resize -2<CR>", opt)
map("n", "<right>", ":vertical resize +2<CR>", opt)
