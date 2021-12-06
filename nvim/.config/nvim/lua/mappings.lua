local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = false }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

map("n", "<Leader><Leader>", "<C-^>zz")

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
map("n", "j", "gj")
map("n", "k", "gk")

-- Keep selection when indent/outdent
map("x", ">", ">gv")
map("x", "<", "<gv")

-- format
map("n", "<Leader>fm", ":Format<CR>", opt)

-- OPEN TERMINALS --
map("n", "<Leader>tv", ":vnew +terminal | setlocal nobuflisted <CR>", opt) -- term over right
map("n", "<Leader>tx", ":10new +terminal | setlocal nobuflisted <CR>", opt) --  term bottom

-- Nvimtree (rest are defaults)
map("n", "<C-b>", ":NvimTreeToggle<CR>", opt)

-- Tabs
map("n", "<Leader>tt", ":tabnew<CR>", opt)
map("n", "<Leader>tn", ":tabnext<CR>", opt)
map("n", "<Leader>tp", ":tabprevious<CR>", opt)
map("n", "<Leader>tq", ":tabclose<CR>", opt)

-- return normal mode on esc in terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Telescope
map("n", "<Leader>ff", ":Telescope find_files<CR>", opt)
map("n", "<Leader>fg", ":Telescope git_files<CR>", opt)
map("n", "<Leader>fi", ":Telescope current_buffer_fuzzy_find <CR>", opt)
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
-- map("n", "<Leader>gs", ":Telescope git_status<CR>", opt)
-- map("n", "<Leader>gg", ":Telescope git_bcommits<Cr>", opt)
map("n", "<Leader>gB", ":Telescope git_branches<CR>", opt)
map("n", "<Leader>gl", ":Telescope git_commits<CR>", opt)
map("n", "<leader>gw", ":Telescope git_worktree git_worktrees<CR>", opt)
map("n", "<leader>gm", ":Telescope git_worktree create_git_worktree<CR>", opt)

map("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>", opt)
map("v", "<Leader>gs", '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', opt)
map("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>", opt)
map("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", opt)
map("v", "<Leader>gr", '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>', opt)
map("n", "<Leader>gR", ":Gitsigns reset_buffer<CR>", opt)
map("", "<Leader>gp", ":Gitsigns preview_hunk<CR>", opt)
map("n", "<Leader>gb", ":Gitsigns blame_line<CR>", opt)

map("n", "<Leader>g", ":Neogit<CR>", opt)
map("n", "<Leader>gc", ":Neogit commit<CR>", opt)

-- Markdown
map("n", "<leader>p", ":MarkdownPreviewToggle <CR>")

-- Quickfix
map("", "<C-q>", ":copen<cr>", opt)
map("n", "<C-k>", ":cnext<cr>zz", opt)
map("n", "<C-j>", ":cprevious<cr>zz", opt)

-- map("", "<leader>q", ":lopen<cr>", opt)
map("", "<leader>j", ":lnext<cr>zz", opt)
map("", "<leader>k", ":lprevious<cr>zz", opt)

-- don't be nothered with the type of little window to close, just get rid of it
map("", "cl", ":pclose | lclose | cclose<CR>", opt)

-- LSP
map("n", "gd", ":lua vim.lsp.buf.definition()<CR>zz", opt)
map("n", "gr", ":lua vim.lsp.buf.references()<CR>", opt)
map("n", "gt", ":lua vim.lsp.buf.type_definition()<CR>zz", opt)
map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>zz", opt)
map("n", "K", ":lua vim.lsp.buf.hover()<CR>", opt)
map("n", "S", ":lua vim.lsp.buf.signature_help()<cr>", opt)
map("n", "<Leader>rn", ":lua vim.lsp.buf.rename()<CR>", opt)
map("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", opt)
map("n", "<leader>ds", ":lua vim.diagnostic.open_float()<CR>", opt)
map("n", "<Leader>dn", ":lua vim.diagnostic.goto_next()<CR>", opt)

-- DAP
map("n", "<leader>dc", ":lua require'dap'.continue()<CR>", opt)
map("n", "<leader>do", ":lua require'dap'.step_over()<CR>", opt)
map("n", "<leader>di", ":lua require'dap'.step_into()<CR>", opt)
map("n", "<leader>dx", ":lua require'dap'.step_out()<CR>", opt)
map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opt)
map("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opt)
map("n", "<leader>dp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opt)
map("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>", opt)
map("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", opt)
map("n", "<leader>du", ":lua require'dapui'.toggle()<CR>")
map("n", "<leader>de", ":lua require'dapui'.eval()<CR>")
map("v", "<leader>de", ":lua require'dapui'.eval()<CR>")

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
map("n", "<C-e>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opt)
map("n", "<C-y>", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", opt)
map("n", "<Leader>a", ":lua require('harpoon.mark').add_file()<CR>")
map("n", "<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>zz")
map("n", "<C-t>", ":lua require('harpoon.ui').nav_file(2)<CR>zz")
map("n", "<C-n>", ":lua require('harpoon.ui').nav_file(3)<CR>zz")
map("n", "<C-s>", ":lua require('harpoon.ui').nav_file(4)<CR>zz")
map("n", "<Leader>tu", ":lua require('harpoon.term').gotoTerminal(1)<CR>")
map("n", "<Leader>te", ":lua require('harpoon.term').gotoTerminal(2)<CR>")
map(
  "n",
  "<Leader>cu",
  ":lua require('harpoon.term').sendCommand(2,1); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)
map(
  "n",
  "<Leader>ce",
  ":lua require('harpoon.term').sendCommand(2,2)<CR>:lua require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)

-- Refactoring
map("v", "<Leader>re", ":lua require('refactoring').refactor('Extract Function')<CR>", opt)
map("v", "<Leader>rf", ":lua require('refactoring').refactor('Extract Function To File')<CR>", opt)
map("n", "<Leader>rr", ":lua require('plugins.others').refactors()<CR>", opt)
map("v", "<Leader>rr", ":lua require('plugins.others').refactors()<CR>", opt)

-- cmp
-- toggle cmp completion
map("n", "<Leader>tc", ":lua require('plugins.others').toggle_completion()<CR>", opt)

-- misc
map("n", "<Leader>cd", ":cd %:p:h<CR>:pwd<CR>", opt)
map("n", "Q", "<nop>", opt) -- disable Ex mode
