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
map("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", opt)

-- Tabs
map("n", "tt", ":tabnew<CR>", opt)
map("n", "tn", ":tabnext<CR>", opt)
map("n", "tp", ":tabprevious<CR>", opt)
map("n", "tq", ":tabclose<CR>", opt)

-- return normal mode on esc in terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Telescope
map("n", "<C-P>", ":Telescope find_files<CR>", opt)
map("n", "<Leader>fg", ":Telescope git_files<CR>", opt)
map("n", "<Leader>b", ":Telescope buffers<CR>", opt)
map("n", "<Leader>fo", ":Telescope oldfiles<CR>", opt)
map("n", "<Leader>fw", ":Telescope live_grep<CR>", opt)
map("n", "<Leader>fc", ":lua require('plugins.others').search_dotfiles()<CR>", opt)
map("n", "<leader>pw", ":lua require('telescope.builtin').grep_string {search = vim.fn.expand('<cword>')}<CR>", opt)
map("n", "<leader>ps", ":lua require('telescope.builtin').grep_string {search = vim.fn.input('Grep For > ')}<CR>", opt)

-- Git
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
map("n", "<Leader>gn", ":Gitsigns next_hunk<CR>", opt)

map("n", "<Leader>g", ":Neogit<CR>", opt)

-- Markdown
map("n", "<leader>p", ":MarkdownPreviewToggle <CR>")

-- Quickfix
map("", "<C-q>", ":copen<cr>", opt)
map("n", "<C-k>", ":cnext<cr>zz", opt)
map("n", "<C-j>", ":cprevious<cr>zz", opt)

-- Arrowkeys
map("", "<up>", "<nop>", opt)
map("", "<down>", "<nop>", opt)
map("", "<left>", "<nop>", opt)
map("", "<right>", "<nop>", opt)

-- horizontal & vertical resize using arrow keys
map("n", "<up>", ":resize +4<CR>", opt)
map("n", "<down>", ":resize -4<CR>", opt)
map("n", "<left>", ":vertical resize -4<CR>", opt)
map("n", "<right>", ":vertical resize +4<CR>", opt)

-- Harpoon
map("n", "<C-e>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opt)
map("n", "<C-y>", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", opt)
map("n", "<Leader>a", ":lua require('harpoon.mark').add_file()<CR>")
map("n", "<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>zz")
map("n", "<C-t>", ":lua require('harpoon.ui').nav_file(2)<CR>zz")
map("n", "<C-n>", ":lua require('harpoon.ui').nav_file(3)<CR>zz")
map("n", "<C-s>", ":lua require('harpoon.ui').nav_file(4)<CR>zz")
map("n", "tu", ":lua require('harpoon.term').gotoTerminal(1)<CR>")
map("n", "te", ":lua require('harpoon.term').gotoTerminal(2)<CR>")
map(
  "n",
  "cu",
  ":lua require('harpoon.term').sendCommand(2,1); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)
map(
  "n",
  "ce",
  ":lua require('harpoon.term').sendCommand(2,2); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)

-- misc
map("n", "Q", "<nop>", opt) -- disable Ex mode
