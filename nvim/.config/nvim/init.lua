pcall(require, "impatient")

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.api.nvim_command("packadd packer.nvim")
end

require("packer").startup(function(use)
  -- Plugin Manager
  use({ "wbthomason/packer.nvim" })

  use("lewis6991/impatient.nvim")

  use({
    "williamboman/nvim-lsp-installer",
    {
      "neovim/nvim-lspconfig",
    },
  })

  use({
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
    },
    {
      "nvim-treesitter/nvim-treesitter-refactor",
      after = "nvim-treesitter",
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
    },
    {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
    },
  })

  use({ "rafamadriz/friendly-snippets" })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "petertriho/cmp-git",
    },
  })

  use({
    "mhartington/formatter.nvim",
    cmd = "Format",
  })

  -- File tree
  use({
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle", "NvimTreeFocus" },
  })

  -- statusline
  use({
    "hoob3rt/lualine.nvim",
  })

  -- color/theme related stuff
  use({ "KasonBraley/nvim-solarized-lua" })
  -- local theme development
  -- use({ "~/dev/lua/nvim-solarized-lua" })

  use({
    "norcalli/nvim-colorizer.lua",
    event = "Bufread",
    config = function()
      require("colorizer").setup()
    end,
  })

  -- git
  use({
    {
      "lewis6991/gitsigns.nvim",
      event = "Bufread",
      config = function()
        require("gitsigns").setup()
      end,
    },
    {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("neogit").setup()
      end,
    },
    { "ThePrimeagen/git-worktree.nvim" },
  })

  -- Fuzzy Finder
  use({
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    },
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  })

  use({ "nvim-lua/popup.nvim" })

  use({
    "ThePrimeagen/harpoon",
    commit = "7cf2e20a411ea106d7367fab4f10bf0243e4f2c2",
  })

  use({ "andymass/vim-matchup", event = "BufRead" })

  use({
    {
      "numToStr/Comment.nvim",
      event = "BufRead",
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
    },
  })

  use({ "machakann/vim-sandwich", event = "BufRead" })

  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  })

  use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if packer_bootstrap then
  print("==================================")
  print("    Plugins are being installed")
  print("    Wait until Packer completes,")
  print("       then restart nvim")
  print("==================================")
  return
end

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

opt.grepprg = "rg"
opt.grepprg = "rg --color=never --no-heading --line-number --column"

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

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- custom telescope search functions
local search_dotfiles = function()
  require("telescope.builtin").git_files({
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    hidden = true,
    cwd = "~/dotfiles",
    file_ignore_patterns = {
      "*.png",
      "*.jpg",
      "node_modules/*",
      "dist/*",
    },
    layout_strategy = "bottom_pane",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.5,
      height = 0.5,
      preview_cutoff = 10,
    },
  })
end

local goimports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.formatting_sync()
end

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
vim.keymap.set("n", "<Leader>fc", search_dotfiles)
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

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = "[Buff]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        spell = "[Spell]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  sources = {
    { name = "path" },
    { name = "nvim_lsp", max_item_count = 10 },
    { name = "luasnip" },
    -- { name = "buffer", keyword_length = 5, max_item_count = 5 },
    { name = "spell" },
    { name = "cmp_git" },
  },
  enabled = function()
    -- disable completion in comments
    local context = require("cmp.config.context")
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end
  end,
})

require("Comment").setup({
  pre_hook = function(ctx)
    local U = require("Comment.utils")

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring({
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    })
  end,
})

local prettier = function()
  return {
    exe = "prettier",
    args = { "--stdin", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
    stdin = true,
  }
end

require("formatter").setup({
  logging = false,
  filetype = {
    javascript = { prettier },
    javascriptreact = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    markdown = { prettier },
    css = { prettier },
    json = { prettier },
    jsonc = { prettier },
    yaml = { prettier },
    html = { prettier },
    go = {
      function()
        return {
          exe = "goimports",
          args = { "-w", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
          stdin = false,
        }
      end,
    },
    lua = {
      -- stylua
      function()
        return {
          exe = "stylua",
          args = { "--indent-type", "spaces", "--indent-width", "2", "-" },
          stdin = true,
        }
      end,
    },
    sh = {
      -- Shell Script Formatter
      function()
        return {
          exe = "shfmt",
          -- args = { "-i", 2 },
          stdin = true,
        }
      end,
    },
    terraform = {
      function()
        return {
          exe = "terraform",
          args = { "fmt", "-" },
          stdin = true,
        }
      end,
    },
  },
})

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.setup({
  automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})

local lspconfig = require("lspconfig")

local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = { noremap = true, silent = false }
  buf_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>zz", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>zz", opts)
  buf_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>zz", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "<space>ds", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "<space>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>dl", "<cmd>Telescope diagnostics<CR>", opts)
  buf_set_keymap("n", "<space>fa", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- config that activates keymaps and enables snippet support
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
  "html",
  "cssls",
  -- "tailwindcss",
  "dockerls",
  "gopls",
  "golangci_lint_ls",
  "quick_lint_js",
  "bashls",
  "intelephense",
  "sqls",
  "pyright",
  -- "jdtls",
  "terraformls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      buildFlags = { "-tags=unit,integration,e2e" },
    },
  },
})

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  single_file_support = true,
  handlers = {
    -- disable tsserver diagnostics
    -- ["textDocument/publishDiagnostics"] = function() end,
  },
})

lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json",
        },
      },
    },
  },
})

lspconfig.yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      -- Schemas https://www.schemastore.org
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    -- disable eslint diagnostics for .js files, instead it is handled by quick_lint_js
    -- "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
})

vim.o.termguicolors = true

-- g.nvim_tree_auto_ignore_ft = {} -- don't open tree on specific fiypes.
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_root_folder_modifier = ":t"
vim.g.nvim_tree_allow_resize = 1
vim.g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names

vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  -- folder_arrows= 1
}
vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = "",
    ignored = "◌",
  },
  folder = {
    -- arrow_open = "",
    -- arrow_closed = "",
    default = "",
    open = "",
    empty = "", -- 
    empty_open = "",
    symlink = "",
    symlink_open = "",
  },
}

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  git = {
    ignore = true,
  },
  diagnostics = {
    enable = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },

  filters = {
    dotfiles = false,
    custom = {
      ".git$",
      "node_modules",
      ".cache",
    },
  },

  view = {
    width = 30,
    side = "right",
    mappings = {
      custom_only = false,
      list = {},
    },
  },
})

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "solarized",
    component_separators = { "", "" },
    section_separators = { "", "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 }, "diagnostics", "diff" },
    lualine_x = { "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    selection_strategy = "reset",
    layout_strategy = "bottom_pane",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.5,
      height = 0.5,
      preview_cutoff = 10,
    },
    file_ignore_patterns = {
      ".git/objects/*",
      ".git/refs/*",
      ".git/hooks/*",
      ".git/info/*",
      ".git/logs/*",
      ".git/worktrees/*",
      ".png",
      ".PNG",
      ".jpg",
      ".jpeg",
      "node_modules/*",
      "dist/*",
    },
    -- path_display = { "smart" },
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "git_worktree")
pcall(require("telescope").load_extension, "harpoon")

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "javascript",
    "html",
    "css",
    "typescript",
    "tsx",
    "json",
    "bash",
    "lua",
    "yaml",
    "dockerfile",
    "go",
    "php",
    "python",
    "java",
    "hcl",
  },
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,
    disable = {},
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>s"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>S"] = "@parameter.inner",
      },
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
  },
})

vim.api.nvim_exec(
  [[
   au TermOpen term://* setlocal nonumber norelativenumber laststatus=0 
   au TermOpen term://* startinsert
   au TermClose term://* bd!
   au FileType gitcommit setlocal spell
   au BufRead,BufNewFile *.md setlocal spell
   au BufWrite * set fileformat=unix 
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
   au BufWritePre *.go lua require('plugins.others').goimports(1000)
]],
  false
)

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
