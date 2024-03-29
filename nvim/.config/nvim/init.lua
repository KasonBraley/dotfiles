--Remap space as leader key
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " "

local install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(install_path) then
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

require("lazy").setup({
  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "folke/neodev.nvim",
  { "j-hui/fidget.nvim", tag = "legacy" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build =
    ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- Git related
  "lewis6991/gitsigns.nvim",
  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim"
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "nvim-telescope/telescope-ui-select.nvim",

  -- File Explorer
  "tpope/vim-vinegar",

  -- Status Line
  "hoob3rt/lualine.nvim",

  -- Color Scheme
  -- "tjdevries/colorbuddy.vim",
  -- "tjdevries/gruvbuddy.nvim",

  "navarasu/onedark.nvim",

  -- Misc.
  -- "nvim-lua/popup.nvim",
  { "ThePrimeagen/harpoon", commit = "7cf2e20a411ea106d7367fab4f10bf0243e4f2c2" },
  "numToStr/Comment.nvim",
  "mhartington/formatter.nvim",

  -- Detect tabstop and shiftwidth automatically
  -- "tpope/vim-sleuth",

  {
    "kylechui/nvim-surround",
    version = "*", --  for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitlinker").setup()
    end,
  },

  {
    "johmsalas/text-case.nvim",
    config = function()
      require('textcase').setup({})
    end
  },

  {
    "icholy/lsplinks.nvim",
  }
})

-- options
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true

vim.opt.colorcolumn = "100"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cul = true
vim.opt.mouse = "a"
-- Disable horizontal scrolling.
vim.o.mousescroll = 'ver:3,hor:0'

vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.updatetime = 200 -- update interval for gitsigns
vim.opt.timeoutlen = 400
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.completeopt = "menuone,noselect"

vim.opt.shortmess:append('c')
vim.opt.completeopt:append {
  'noinsert',
  'menuone',
  'noselect',
  'preview'
}
vim.opt.wrap = false
vim.opt.scrolloff = 8 -- Make it so there are always lines below my cursor

-- Numbers
vim.wo.number = true -- Make line numbers default
vim.opt.numberwidth = 1
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.inccommand = "split"
vim.opt.equalalways = false
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.showmode = false

vim.opt.diffopt:append {
  'linematch:50',
  'vertical',
  'foldcolumn:0',
  'indent-heuristic',
}

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

-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- colorscheme
vim.o.termguicolors = true
vim.cmd("colorscheme onedark")
-- require("colorbuddy").colorscheme("gruvbuddy")
--
-- local Color, colors, Group = require("colorbuddy").setup()
-- Color.new("colorCol", "#282a2e")
-- Group.new("ColorColumn", nil, colors.colorCol)
--
-- Color.new("neogitRed", "#cc6666")
-- Group.new("NeogitDiffDelete", nil, colors.neogitRed)

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

-- Markdown
vim.keymap.set("n", "<Leader>p", ":MarkdownPreviewToggle <CR>")

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

-- gitsigns
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    map("n", "<leader>hu", gs.undo_stage_hunk)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end)
    map("n", "<leader>tb", gs.toggle_current_line_blame)
    map("n", "<leader>hd", gs.diffthis)
  end,
})

-- neogit
require("neogit").setup({})

vim.keymap.set("n", "<Leader>g", ":Neogit<CR>")

require("Comment").setup({
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
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
    yaml = { prettier },
    html = { prettier },
    sh = {
      function()
        return {
          exe = "shfmt",
          stdin = true,
        }
      end,
    },
  },
})

-- #373b41 greyish text fg
-- #81a2be light blue - default statusline color
local statusLineTheme = {
  normal = {
    a = { bg = "#282c34", fg = "#f8fe7a" },
    b = { bg = "#282a2e", fg = "#81a2be" },
    c = { bg = "#282a2e", fg = "#81a2be" },
    z = { bg = "#282a2e", fg = "#81a2be" },
  },
  insert = {
    a = { bg = "#282a2e", fg = "#81a2be" },
    b = { bg = "#282a2e", fg = "#81a2be" },
    c = { bg = "#282a2e", fg = "#81a2be" },
    z = { bg = "#282a2e", fg = "#81a2be" },
  },
}

-- statusline
require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = statusLineTheme,
    component_separators = { "", "" },
    section_separators = { "", "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { "%=", { "filename", path = 1 } },
    lualine_x = { "diagnostics" },
    lualine_y = { "encoding", "filetype" },
    lualine_z = { "location" },
  },
  extensions = { "quickfix" },
})

local actions = require("telescope.actions")
local action_layout = require "telescope.actions.layout"

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
    file_ignore_patterns = {
      "^.git/",
      ".png",
      ".PNG",
      ".jpg",
      ".jpeg",
      "^node_modules/",
      "^dist/",
    },
    mappings = {
      i = {
        ["<M-p>"] = action_layout.toggle_preview,
        ["<M-m>"] = action_layout.toggle_mirror,
        ["<C-k>"] = actions.cycle_history_next,
        ["<C-j>"] = actions.cycle_history_prev,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
})

pcall(require("telescope").load_extension("fzf")) -- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension("ui-select"))

local search_dotfiles = function()
  require("telescope.builtin").git_files({
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    hidden = true,
    cwd = "~/dotfiles",
  })
end

local builtin = require("telescope.builtin")
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"

local flatten = vim.tbl_flatten

local multi_rg = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.shortcuts = opts.shortcuts
      or {
        ["l"] = "*.lua",
        ["j"] = "*.js",
        ["p"] = "*.php",
      }
  opts.pattern = opts.pattern or "%s"

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local prompt_split = vim.split(prompt, "  ")

      local args = { "rg" }
      if prompt_split[1] then
        table.insert(args, "-e")
        table.insert(args, prompt_split[1])
      end

      if prompt_split[2] then
        table.insert(args, "-g")

        local pattern
        if opts.shortcuts[prompt_split[2]] then
          pattern = opts.shortcuts[prompt_split[2]]
        else
          pattern = prompt_split[2]
        end

        table.insert(args, string.format(opts.pattern, pattern))
      end

      return flatten {
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
          "--smart-case" },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Live Grep (with shortcuts)",
    finder = custom_grep,
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
  }):find()
end

vim.keymap.set("n", "<C-P>", builtin.find_files)
vim.keymap.set("n", "<Leader>fg", builtin.git_files)
vim.keymap.set("n", "<Leader>b", builtin.buffers)
vim.keymap.set("n", "<Leader>fo", builtin.oldfiles)
vim.keymap.set("n", "<Leader>fc", search_dotfiles)

vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>/", multi_rg, { desc = "[S]earch by [G]rep (with shortcuts)" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

-- Harpoon
vim.keymap.set("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
-- vim.keymap.set("n", "<C-y>", require("harpoon.cmd-ui").toggle_quick_menu)
vim.keymap.set("n", "<Leader>a", require("harpoon.mark").add_file)
vim.keymap.set("n", "<Leader>j", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<Leader>k", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<Leader>l", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<Leader>;", function() require("harpoon.ui").nav_file(4) end)
vim.keymap.set("n", "tj", function() require("harpoon.term").gotoTerminal(1) end)
vim.keymap.set("n", "tk", function() require("harpoon.term").gotoTerminal(2) end)
vim.keymap.set(
  "n",
  "cj",
  ":lua require('harpoon.term').sendCommand(2,1); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)
vim.keymap.set(
  "n",
  "ck",
  ":lua require('harpoon.term').sendCommand(2,2); require('harpoon.term').gotoTerminal(2)<CR>a<CR>"
)

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
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "javascript",
    "html",
    "css",
    "typescript",
    "tsx",
    "json",
    "bash",
    "yaml",
    "dockerfile",
    "go",
    "hcl",
    "terraform",
    "markdown",
    "rust",
    "php",
    "proto",
    "templ",
    "zig",
  },
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 10000
    end,
  }
})

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  opts = { noremap = true, silent = false, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "S", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set({ "n", "v" }, "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config.
local servers = {
  html = {},
  cssls = {},
  tsserver = {},
  zls = {}, -- zig
  -- golangci_lint_ls = {},
  dockerls = {},
  bashls = {},
  terraformls = {},
  -- rust_analyzer = {},
  intelephense = {
    intelephense = {
      format = {
        braces = "k&r",
      }
    },
  },
  templ = {},

  jsonls = {
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
        {
          fileMatch = { "composer.json" },
          url = "https://raw.githubusercontent.com/composer/composer/main/res/composer-schema.json",
        },
      },
    },
  },

  yamlls = {
    yaml = {
      -- Schemas https://www.schemastore.org
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },

  gopls = {
    gopls = {
      buildFlags = { "-tags=unit,integration,e2e" },
      staticcheck = true,
      analyses = {
        unusedparams = true,
        nillness = true,
        unusedwrite = true,
        unusedvariable = true,
      },
      codelenses = {
        test = true,
        tidy = true,
      },
    },
  },

  lua_ls = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME }
      },
      telemetry = { enable = false },
      format = { enable = true },
    },
  },
}

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- config that activates keymaps and enables snippet support
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup()

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = servers[server_name],
    }
  end,
}

local lsp_types = require("cmp.types")

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  -- view = {
  --   docs = {
  --     auto_open = false,
  --   }
  -- },
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
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    -- ['<C-g>'] = function()
    --   if cmp.visible_docs() then
    --     cmp.close_docs()
    --   else
    --     cmp.open_docs()
    --   end
    -- end
  }),
  sources = {
    { name = "path" },
    {
      name = "nvim_lsp",
      max_item_count = 10,
      entry_filter = function(entry, ctx)
        local kind = lsp_types.lsp.CompletionItemKind[entry:get_kind()]

        -- remove Modules from completion options
        if kind == "Module" then
          return false
        end
        return true
      end

    },
    { name = "nvim_lsp_signature_help" },
    { name = "luasnip" },
    { name = "spell" },
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

require("fidget").setup({})

-- terminal: disable line numbers and start in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.cmd.setlocal("nonumber norelativenumber")
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

vim.keymap.set("n", "<Leader>l", ":lua require('textcase').current_word('to_pascal_case')<CR> <CR>")

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

local lsplinks = require("lsplinks")
lsplinks.setup({
  highlight = false
})
vim.keymap.set("n", "gx", lsplinks.gx)
