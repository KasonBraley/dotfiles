local function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local opt = {}

-- map navigation between splits using <C-{h,j,k,l}>
map("n", "<C-k>", [[<Cmd> wincmd k<CR>]])
map("n", "<C-l>", [[<Cmd> wincmd l<CR>]])
map("n", "<C-h>", [[<Cmd> wincmd h<CR>]])
map("n", "<C-j>", [[<Cmd> wincmd j<CR>]])

-- horizontal & vertical resize
map("n", "+", [[<Cmd> vertical resize +5<CR>]])
map("n", "_", [[<Cmd> vertical resize -5<CR>]])
map("n", "<leader>=", [[<Cmd> resize +5<CR>]])
map("n", "<leader>-", [[<Cmd> resize -5<CR>]])

-- OPEN TERMINALS --
map("n", "<C-v>", [[<Cmd>vnew term:// <CR>]], opt) -- term over right map("n", "<C-x>", [[<Cmd> split term:// | resize 10 <CR>]], opt) --  term bottom
map("n", "<C-t>t", [[<Cmd> tabnew | term <CR>]], opt) -- term newtab

-- copy whole file content
map("n", "<C-a>", [[ <Cmd> %y+<CR>]], opt)

-- nvimtree (rest are defaults)
map("n", "<C-n>", ":NvimTreeToggle<CR>", opt)

-- buffer delete
map("n", "<C-q>", ":Bdelete<CR>", opt)

-- Bufferline tabs
map("n", "<S-t>", ":tabnew<CR>", opt) -- new tab
map("n", "<S-x>", ":Bdelete<CR>", opt) -- close tab
map("n", "<S-x>x", ":Bdelete!<CR>", opt) -- force close tab

-- move between tabs
map("n", "<Tab>", [[<Cmd>BufferLineCycleNext<CR>]], opt)
map("n", "<S-Tab>", [[<Cmd>BufferLineCyclePrev<CR>]], opt)

-- remove highlighted selection
map("n", "<leader><Esc>", [[<Cmd> noh <CR>]], {silent = true})

-- save
map("n", "zs", ":w<CR>", {silent = true})
map("n", "<C-s>", ":w!<CR>", opt)

-- return normal mode on esc in terminal
map("t", "<Esc>", [[<C-\><C-n>]], {silent = true})

-- dashboard stuff
map("n", "<Leader>fg", [[<Cmd> Telescope live_grep<CR>]], opt)
map("n", "<Leader>db", [[<Cmd> Dashboard<CR>]], opt)
map("n", "<Leader>fn", [[<Cmd> DashboardNewFile<CR>]], opt)
map("n", "<Leader>bm", [[<Cmd> DashboardJumpMarks<CR>]], opt)
map("n", "<C-s>l", [[<Cmd> SessionLoad<CR>]], opt)
map("n", "<C-s>s", [[<Cmd> SessionSave<CR>]], opt)

-- Telescope
map("n", "<Leader>gt", [[<Cmd> Telescope git_status <CR>]], opt)
map("n", "<Leader>cm", [[<Cmd> Telescope git_commits <CR>]], opt)
map("n", "<Leader>ff", [[<Cmd> Telescope find_files <CR>]], opt)
map("n", "<Leader>fp", [[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]], opt)
map("n", "<Leader>fb", [[<Cmd>Telescope buffers<CR>]], opt)
map("n", "<Leader>fh", [[<Cmd>Telescope help_tags<CR>]], opt)
map("n", "<Leader>fo", [[<Cmd>Telescope oldfiles<CR>]], opt)

-- lazy git
local Terminal = require("toggleterm.terminal").Terminal
local lazygit =
  Terminal:new(
  {
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double"
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd("Closing terminal")
    end
  }
)

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

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
map("", "<leader>j", "<cmd>HopWord<CR>", opt)
map("", "<leader>l", "<cmd>HopLineStart<CR>", opt)
map("", "<leader>s", "<cmd>HopPattern<CR>", opt)
map("", "<leader>c", "<cmd>HopChar1<CR>", opt)
