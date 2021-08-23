local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

map("n", "<Leader><Leader>", "<C-^>")

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
map("n", "j", "gj")
map("n", "k", "gk")

-- Keep selection when indent/outdent
map("x", ">", ">gv")
map("x", "<", "<gv")

-- Commenter Keybinding
vim.api.nvim_set_keymap("", "<leader>/", ":CommentToggle<CR>", opt)

-- format
map("n", "<Leader>fm", ":Format<CR>", opt)

-- OPEN TERMINALS --
map("n", "<C-v>", ":vnew +terminal | setlocal nobuflisted <CR>", opt) -- term over right
map("n", "<C-x>", ":10new +terminal | setlocal nobuflisted <CR>", opt) --  term bottom

-- Nvimtree (rest are defaults)
-- pv for "project view"
map("n", "<C-a>", ":NvimTreeToggle<CR>", opt)

-- Bufferline tabs
map("n", "<C-t>", ":enew<CR>", opt) -- new buffer
map("n", "<S-x>", ":Bdelete<CR>", opt) -- close tab
map("n", "<S-x>x", ":Bdelete!<CR>", opt) -- force close tab
map("n", "<Tab>", ":TablineBufferNext<CR>", opt) -- next buffer
map("n", "<S-Tab>", ":TablineBufferPrevious<CR>", opt) -- previous buffer
map("n", "<Leader>tt", ":TablineTabNew ", opt) -- new tab
map("n", "<Leader>ta", ":TablineToggleShowAllBuffers<CR>", opt)
map("n", "<Leader>tb", ":TablineBuffersBind ", opt)
map("n", "<Leader>tc", ":TablineBuffersClearBind<CR>", opt)
map("n", "<Leader>tr", ":TablineTabRename ", opt)
map("n", "<Leader>tn", ":tabnext<CR>", opt)
map("n", "<Leader>tp", ":tabprevious<CR>", opt)

-- remove highlighted selection
map("n", "<Esc>", ":noh<CR>", opt)

-- return normal mode on esc in terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Telescope
map("n", "<Leader>ff", ":Telescope find_files <CR>", opt)
map("n", "<C-h>", ":Telescope git_files<CR>", opt)
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
map("n", "<leader>ps", ":lua require('telescope.builtin').grep_string {search = vim.fn.input('Grep For > ')}<CR>", opt)
map("n", "<leader>fB", ":Telescope builtin<CR>", opt)
map("n", "<leader>fs", ":Telescope treesitter<CR>", opt)

-- Git
map("n", "<Leader>gs", ":Telescope git_status<CR>", opt)
-- map("n", "<Leader>gg", ":Telescope git_bcommits<Cr>", opt)
map("n", "<Leader>gB", ":Telescope git_branches<CR>", opt)
map("n", "<Leader>gl", ":Telescope git_commits<CR>", opt)
map("n", "<leader>wg", ":Telescope git_worktree git_worktrees<CR>", opt)
map("n", "<leader>wc", ":Telescope git_worktree create_git_worktree<CR>", opt)

map("n", "<Leader>g", ":Neogit<CR>", opt)
map("n", "<Leader>gc", ":Neogit commit<CR>", opt)

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

-- toggle focus of one window split

-- Markdown
map("n", "<leader>p", ":MarkdownPreviewToggle <CR>")

-- Quickfix
-- map("", "<C-q>", ":copen<cr>", opt)
-- map("", "<C-j>", ":cnext<cr>", opt)
-- map("", "<C-k>", ":cprevious<cr>", opt)

-- map("", "<leader>q", ":lopen<cr>", opt)
-- map("", "<leader>n", ":lnext<cr>", opt)
-- map("", "<leader>k", ":lprevious<cr>", opt)

-- don't be nothered with the type of little window to close, just get rid of it
map("", "cl", ":pclose | lclose | cclose<CR>", opt)

-- lspsaga
map("n", "gh", ":Lspsaga lsp_finder<CR>", opt)
map("n", "gd", ":Lspsaga preview_definition<CR>", opt)
map("n", "K", ":Lspsaga hover_doc<CR>", opt)
map("n", "<C-s>", ":Lspsaga signature_help<CR>", opt)
map("i", "<C-s>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opt)
map("n", "<Leader>rn", ":Lspsaga rename<CR>", opt)
map("n", "<leader>.a", ":Lspsaga code_action<CR>", opt)
map("v", "<leader>ca", ":Lspsaga range_code_action<CR>", opt)
map("n", "<leader>.;", ":Lspsaga show_line_diagnostics<CR>", opt)
map("n", "<Leader>.l", ":Lspsaga diagnostic_jump_next<CR>", opt)

-- scroll down hover doc or scroll in definition preview
-- map("n", "<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opt)
-- scroll up hover doc
-- map("n", "<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opt)

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

-- Harpoon
map("n", "<C-f>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opt)
map("n", "<Leader>a", ":lua require('harpoon.mark').add_file()<CR>")
map("n", "<C-j>", ":lua require('harpoon.ui').nav_file(1)<CR>")
map("n", "<C-k>", ":lua require('harpoon.ui').nav_file(2)<CR>")
map("n", "<C-l>", ":lua require('harpoon.ui').nav_file(3)<CR>")
map("n", "<C-h>", ":lua require('harpoon.ui').nav_file(4)<CR>")
map("n", "<Leader>kf", ":lua require('harpoon.term').gotoTerminal(1)<CR>")
map("n", "<Leader>kd", ":lua require('harpoon.term').gotoTerminal(2)<CR>")
map(
  "n",
  "<Leader>uf",
  ":lua require('harpoon.term').sendCommand(1,'ls -a'); require('harpoon.term').gotoTerminal(1)<CR>"
)
-- map("n", "<Leader>ue", ":lua require('harpoon.term').sendCommand(1,)<CR>")

-- Refactoring
map("v", "<Leader>re", ":lua require('refactoring').refactor('Extract Function')<CR>", opt)
map("v", "<Leader>rf", ":lua require('refactoring').refactor('Extract Function To File')<CR>", opt)
map("n", "<Leader>rr", ":lua require('plugins.others').refactors()<CR>", opt)
map("v", "<Leader>rr", ":lua require('plugins.others').refactors()<CR>", opt)

-- misc
map("n", "<Leader>cd", ":cd %:p:h<CR>:pwd<CR>", opt)
