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
  use("wbthomason/packer.nvim") -- Plugin Manager
  use("lewis6991/impatient.nvim")
  use("williamboman/nvim-lsp-installer")
  use("neovim/nvim-lspconfig")
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/nvim-treesitter-refactor")
  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("rafamadriz/friendly-snippets")
  use({ "hrsh7th/nvim-cmp", requires = { "hrsh7th/cmp-nvim-lsp" } })
  use({ "L3MON4D3/LuaSnip", requires = { "saadparwaiz1/cmp_luasnip" } })
  use("hrsh7th/cmp-path")
  use("f3fora/cmp-spell")
  use("mhartington/formatter.nvim")
  use("kyazdani42/nvim-tree.lua")
  use("hoob3rt/lualine.nvim")
  use("KasonBraley/nvim-solarized-lua")
  use("lewis6991/gitsigns.nvim")
  use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
  use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-lua/popup.nvim")
  use({ "ThePrimeagen/harpoon", commit = "7cf2e20a411ea106d7367fab4f10bf0243e4f2c2" })
  use("andymass/vim-matchup")
  use("numToStr/Comment.nvim")
  use({ "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" })
  use("machakann/vim-sandwich")
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

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
opt.completeopt = "menu,noselect"
opt.wrap = false
opt.scrolloff = 8 -- Make it so there are always lines below my cursor

opt.grepprg = "rg"
opt.grepprg = "rg --color=never --no-heading --line-number --column"

-- Numbers
vim.wo.number = true --Make line numbers default
opt.numberwidth = 2
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- colorscheme
vim.o.termguicolors = true
vim.cmd([[colorscheme solarized]])

-- vim-matchup
vim.g.matchup_matchparen_offscreen = {}

vim.keymap.set("n", "<Leader><Leader>", "<C-^>zz")

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
vim.keymap.set("n", "tt", ":tabnew<CR>")
vim.keymap.set("n", "tn", ":tabnext<CR>")
vim.keymap.set("n", "tp", ":tabprevious<CR>")
vim.keymap.set("n", "tq", ":tabclose<CR>")

-- return normal mode on esc in terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

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

-- misc
vim.keymap.set("", "Q", "<Nop>", { silent = true }) -- disable Ex mode
vim.api.nvim_create_user_command("W", ":w", {}) --map :W to :w

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

-- gitsigns
require("gitsigns").setup()
vim.keymap.set("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>")
vim.keymap.set("v", "<Leader>gs", function()
  require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>")
vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>")
vim.keymap.set("v", "<Leader>gr", function()
  require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end)
vim.keymap.set("n", "<Leader>gR", ":Gitsigns reset_buffer<CR>")
vim.keymap.set("", "<Leader>gp", ":Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "<Leader>gb", ":Gitsigns blame_line<CR>")
vim.keymap.set("n", "<Leader>gn", ":Gitsigns next_hunk<CR>")

-- neogit
require("neogit").setup()
vim.keymap.set("n", "<Leader>g", ":Neogit<CR>")

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

-- Formatter
vim.keymap.set("n", "<Leader>fm", ":Format<CR>")

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

-- format Go with goimports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    goimports(1000)
  end,
})

-- Nvimtree
vim.keymap.set("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", { silent = true })

require("nvim-tree").setup({
  diagnostics = {
    enable = true,
    icons = {
      hint = "H",
      info = "I",
      warning = "W",
      error = "E",
    },
  },
  filters = {
    dotfiles = false,
    custom = {
      ".git$",
      "node_modules",
      ".cache",
    },
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "icon",
    root_folder_modifier = ":t",
    icons = {
      show = {
        file = false,
        folder = false,
        git = true,
      },
      glyphs = {
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
      },
    },
  },
  view = { width = 30, side = "right" },
})

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "solarized",
    component_separators = { "", "" },
    section_separators = { "", "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 }, "diagnostics", "diff" },
    lualine_x = { "encoding", "filetype" },
    lualine_y = {},
    lualine_z = { "location" },
  },
  extensions = { "quickfix" },
})

-- Telescope

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
      "^./.git/",
      ".png",
      ".PNG",
      ".jpg",
      ".jpeg",
      "^node_modules/",
      "^dist/",
    },
    set_env = { ["COLORTERM"] = "truecolor" },
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  },
  pickers = {
    find_files = {
      hidden = true,
    },
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

pcall(require("telescope").load_extension, "fzf") -- Enable telescope fzf native, if installed

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

vim.keymap.set("n", "<C-P>", function()
  require("telescope.builtin").find_files()
end)
vim.keymap.set("n", "<Leader>fg", require("telescope.builtin").git_files)
vim.keymap.set("n", "<Leader>b", require("telescope.builtin").buffers)
vim.keymap.set("n", "<Leader>fo", require("telescope.builtin").oldfiles)
vim.keymap.set("n", "<Leader>fw", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<Leader>fc", search_dotfiles)
vim.keymap.set("n", "<Leader>pw", function()
  require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end)
vim.keymap.set("n", "<Leader>ps", function()
  require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ") })
end)
vim.keymap.set("n", "<space>dl", require("telescope.builtin").diagnostics)
vim.keymap.set("n", "<Leader>gw", ":Telescope git_worktree git_worktrees<CR>")
vim.keymap.set("n", "<Leader>gm", ":Telescope git_worktree create_git_worktree<CR>")

-- Harpoon
vim.keymap.set("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
vim.keymap.set("n", "<C-y>", require("harpoon.cmd-ui").toggle_quick_menu)
vim.keymap.set("n", "<Leader>a", require("harpoon.mark").add_file)
vim.keymap.set("n", "<C-h>", function()
  require("harpoon.ui").nav_file(1)
end)
vim.keymap.set("n", "<C-t>", function()
  require("harpoon.ui").nav_file(2)
end)
vim.keymap.set("n", "<C-n>", function()
  require("harpoon.ui").nav_file(3)
end)
vim.keymap.set("n", "<C-s>", function()
  require("harpoon.ui").nav_file(4)
end)
vim.keymap.set("n", "tu", function()
  require("harpoon.term").gotoTerminal(1)
end)
vim.keymap.set("n", "te", function()
  require("harpoon.term").gotoTerminal(2)
end)
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

-- diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

vim.keymap.set("n", "<space>ds", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>dn", vim.diagnostic.goto_next)

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
  highlight = { enable = true },
  matchup = {
    enable = true,
    disable = {},
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

-- lsp
local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")

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

local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { silent = false, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "S", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<space>fa", vim.lsp.buf.formatting, opts)
end

-- config that activates keymaps and enables snippet support
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
  "html",
  "cssls",
  "dockerls",
  "gopls",
  -- "golangci_lint_ls",
  "quick_lint_js",
  "bashls",
  "intelephense",
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

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        maxPreload = 2000,
        preloadFileSize = 1000,
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

-- nvim-cmp
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
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        spell = "[Spell]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = "path" },
    { name = "nvim_lsp", max_item_count = 10 },
    { name = "luasnip" },
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

vim.api.nvim_exec(
  [[
   au TermOpen term://* setlocal nonumber norelativenumber
   au TermOpen term://* startinsert
   au TermClose term://* bd!
   au FileType gitcommit setlocal spell
   au BufRead,BufNewFile *.md setlocal spell
   au BufWrite * set fileformat=unix 
   au BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]],
  false
)
