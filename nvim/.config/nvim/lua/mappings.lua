vim.keymap.set("n", "<Leader><Leader>", "<C-^>zz")

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")

-- 'j' and 'k' moves up and down visible lines in editor not actual lines
-- This is noticable when text wraps to next line
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Keep selection when indent/outdent
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

-- format
vim.keymap.set("n", "<Leader>fm", ":Format<CR>")

-- OPEN TERMINALS --
vim.keymap.set("n", "<Leader>tv", ":vnew +terminal | setlocal nobuflisted <CR>") -- term over right
vim.keymap.set("n", "<Leader>tx", ":10new +terminal | setlocal nobuflisted <CR>") --  term bottom

-- Nvimtree (rest are defaults)
vim.keymap.set("n", "<C-b>", ":NvimTreeFindFileToggle<CR>")

-- Tabs
vim.keymap.set("n", "tt", ":tabnew<CR>")
vim.keymap.set("n", "tn", ":tabnext<CR>")
vim.keymap.set("n", "tp", ":tabprevious<CR>")
vim.keymap.set("n", "tq", ":tabclose<CR>")

-- return normal mode on esc in terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Telescope
vim.keymap.set("n", "<C-P>", function()
  require("telescope.builtin").find_files()
end)
vim.keymap.set("n", "<Leader>fg", ":Telescope git_files<CR>")
vim.keymap.set("n", "<Leader>b", ":Telescope buffers<CR>")
vim.keymap.set("n", "<Leader>fo", ":Telescope oldfiles<CR>")
vim.keymap.set("n", "<Leader>fw", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<Leader>fc", ":lua require('plugins.others').search_dotfiles()<CR>")
vim.keymap.set(
  "n",
  "<Leader>pw",
  ":lua require('telescope.builtin').grep_string {search = vim.fn.expand('<cword>')}<CR>"
)
vim.keymap.set(
  "n",
  "<Leader>ps",
  ":lua require('telescope.builtin').grep_string {search = vim.fn.input('Grep For > ')}<CR>"
)

-- Git
vim.keymap.set("n", "<Leader>gw", ":Telescope git_worktree git_worktrees<CR>")
vim.keymap.set("n", "<Leader>gm", ":Telescope git_worktree create_git_worktree<CR>")

vim.keymap.set("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("v", "<Leader>gs", '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>')
vim.keymap.set("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>")
vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>")
vim.keymap.set("v", "<Leader>gr", '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>')
vim.keymap.set("n", "<Leader>gR", ":Gitsigns reset_buffer<CR>")
vim.keymap.set("", "<Leader>gp", ":Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<Leader>gb", ":Gitsigns blame_line<CR>")
vim.keymap.set("n", "<Leader>gn", ":Gitsigns next_hunk<CR>")

vim.keymap.set("n", "<Leader>g", ":Neogit<CR>")

-- Markdown
vim.keymap.set("n", "<Leader>p", ":MarkdownPreviewToggle <CR>")

-- Quickfix
vim.keymap.set("", "<C-q>", ":copen<cr>")
vim.keymap.set("n", "<C-k>", ":cnext<cr>zz")
vim.keymap.set("n", "<C-j>", ":cprevious<cr>zz")

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

-- Harpoon
vim.keymap.set("n", "<C-e>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
vim.keymap.set("n", "<C-y>", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>")
vim.keymap.set("n", "<Leader>a", ":lua require('harpoon.mark').add_file()<CR>")
vim.keymap.set("n", "<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>zz")
vim.keymap.set("n", "<C-t>", ":lua require('harpoon.ui').nav_file(2)<CR>zz")
vim.keymap.set("n", "<C-n>", ":lua require('harpoon.ui').nav_file(3)<CR>zz")
vim.keymap.set("n", "<C-s>", ":lua require('harpoon.ui').nav_file(4)<CR>zz")
vim.keymap.set("n", "tu", ":lua require('harpoon.term').gotoTerminal(1)<CR>")
vim.keymap.set("n", "te", ":lua require('harpoon.term').gotoTerminal(2)<CR>")
vim.keymap.set(
  "n",
  "cu",
  ":lua require('harpoon.term').sendCommand(2,1); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)
vim.keymap.set(
  "n",
  "ce",
  ":lua require('harpoon.term').sendCommand(2,2); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)

-- misc
vim.keymap.set("n", "Q", "<nop>") -- disable Ex mode
