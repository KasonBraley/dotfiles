-- Remap space as leader key
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = " "

vim.g.loaded_matchparen = 0
vim.g.zig_fmt_autosave = 0

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
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Mappings.
          local opts = { noremap = true, silent = false, buffer = event.buf }
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

          -- Fuzzy find all the symbols in your current document.
          -- Symbols are things like variables, functions, types, etc.
          vim.keymap.set("n", "gs", require("telescope.builtin").lsp_document_symbols, opts)
          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set("n", "gS",
            require("telescope.builtin").lsp_dynamic_workspace_symbols,
            opts)

          -- vim.keymap.set({ "n", "v" }, "<space>cc", vim.lsp.codelens.run, opts)
          -- vim.keymap.set("n", "<space>cC", vim.lsp.codelens.refresh, opts)
        end
      })

      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config.
      local servers = {
        html = {},
        cssls = {},
        ts_ls = {},
        zls = {}, -- zig
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
                url =
                "https://raw.githubusercontent.com/composer/composer/main/res/composer-schema.json",
              },
            },
          },
        },

        yamlls = {
          yaml = {
            -- Schemas https://www.schemastore.org
            schemas = {
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "docker-compose.yml",
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
        },

        gopls = {
          gopls = {
            buildFlags = { "-tags=unit,integration,e2e" },
            staticcheck = true,
            usePlaceholders = false,
            analyses = {
              unusedparams = true,
              nillness = true,
              unusedwrite = true,
              unusedvariable = true,
            },
            -- codelenses = {
            --   test = true,
            --   tidy = true,
            -- },
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
            diagnostics = {
              disable = {
                'missing-fields',
              },
            },
          },
        },
      }

      -- config that activates keymaps and enables snippet support
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities,
        require('cmp_nvim_lsp').default_capabilities())

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})

      local mason_lspconfig = require("mason-lspconfig")

      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
              server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        }
      }

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      -- Markdown popup
      do
        local default = vim.lsp.util.open_floating_preview

        vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
          -- This makes the separator between the definition and description look a
          -- bit better, instead of it looking like a distracting black line.
          local buf, win = default(contents, syntax, opts)
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

          for i, line in ipairs(lines) do
            if vim.startswith(line, '─') and vim.endswith(line, '─') then
              vim.api.nvim_buf_add_highlight(buf, -1, 'TelescopeBorder', i - 1, 0, -1)
            end
          end

          return buf, win
        end
      end

      local float_width = 120
      local float_height = 20

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
        max_width = float_width,
        max_heigh = float_height,
      })
    end
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
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
          -- php ts extension currently causes silent panics. very annoying. can't grep in codebases with
          -- telescope due to this, it just crashes neovim.
          -- https://github.com/tree-sitter/tree-sitter-php/issues/238
          -- "php",
          "proto",
          "templ",
          "zig",
        },
        indent = {
          enable = false,
          disable = { "yaml" },
        },
        highlight = {
          enable = true,
          disable = function(_, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end,
        },
      })
    end
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
    },
    config = function()
      local cmp = require('cmp')

      local function toggle_autocomplete()
        local current_setting = cmp.get_config().completion.autocomplete
        if current_setting and #current_setting > 0 then
          cmp.setup({ completion = { autocomplete = false } })
          vim.notify('Autocomplete disabled')
        else
          cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
          vim.notify('Autocomplete enabled')
        end
      end

      vim.api.nvim_create_user_command('NvimCmpToggle', toggle_autocomplete, {})
      vim.keymap.set("n", "<Leader>tc", ":NvimCmpToggle<CR>", { noremap = true, silent = true })

      -- local lsp_types = require("cmp.types")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        completion = {
          autocomplete = false,
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
        }),
        sources = {
          { name = "path" },
          {
            name = "nvim_lsp",
            max_item_count = 10,
            -- entry_filter = function(entry, _)
            --   local kind = lsp_types.lsp.CompletionItemKind[entry:get_kind()]
            --   -- remove Modules from completion options
            --   if kind == "Module" then
            --     return false
            --   end
            --   return true
            -- end
          },
          { name = "nvim_lsp_signature_help" },
          { name = "spell" },
        },
        enabled = function()
          -- disable completion in comments
          local context = require("cmp.config.context")
          return not context.in_treesitter_capture("comment") and
              not context.in_syntax_group("Comment")
        end,
      })
    end
  },

  -- Git related
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs',
          function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr',
          function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end)
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
      end,
    }
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local actions = require("telescope.actions")
      local action_layout = require "telescope.actions.layout"

      local picker_defaults = {
        previewer = true,
        show_line = true,
        results_title = false,
        preview_title = false,
      }

      -- Telescope
      require("telescope").setup({
        defaults = {
          -- These three settings are optional, but recommended.
          prompt_prefix = '',
          entry_prefix = ' ',
          selection_caret = ' ',

          -- This is the important part: without this, Telescope windows will look a
          -- bit odd due to how borders are highlighted.
          layout_strategy = 'grey',
          layout_config = {
            -- The extension supports both "top" and "bottom" for the prompt.
            prompt_position = 'top',

            -- You can adjust these settings to your liking.
            width = { 0.6, max = 135 },
            height = 0.5,
            horizontal = {
              preview_width = 0.6,
            },
          },
          -- preview = {
          --   hide_on_startup = true,
          -- },
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
          file_browser = picker_defaults,
          find_files = {
            picker_defaults,
            hidden = true,
          },
          git_files = picker_defaults,
          buffers = picker_defaults,
          tags = picker_defaults,
          current_buffer_tags = picker_defaults,
          lsp_references = picker_defaults,
          lsp_document_symbols = picker_defaults,
          lsp_workspace_symbols = picker_defaults,
          lsp_implementations = picker_defaults,
          lsp_definitions = picker_defaults,
          git_commits = picker_defaults,
          git_bcommits = picker_defaults,
          git_branches = picker_defaults,
          treesitter = picker_defaults,
          reloader = picker_defaults,
          help_tags = picker_defaults,
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension("fzf")) -- Enable telescope fzf native, if installed
      pcall(require("telescope").load_extension("ui-select"))
      pcall(require("telescope").load_extension("grey"))

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
    end
  },

  {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    config = true
  },

  -- File Explorer
  {
    'stevearc/oil.nvim',
    config = function()
      require("oil").setup {
        columns = {},
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
          ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
          ["<C-p>"] = false,
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      }

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- Status Line
  "hoob3rt/lualine.nvim",

  {
    "ThePrimeagen/harpoon",
    commit = "7cf2e20a411ea106d7367fab4f10bf0243e4f2c2",
    config = function()
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
    end
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        php = { "pint" },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        java = { "google-java-format" },
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", --  for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
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
    event = { "LspAttach" },
    config = function()
      local lsplinks = require("lsplinks")
      lsplinks.setup({
        highlight = false
      })
      vim.keymap.set("n", "gx", lsplinks.gx)
    end
  },

  "yorickpeterse/nvim-grey",
})

-- options
-- Search
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
vim.opt.pumheight = 30
vim.opt.completeopt = "menuone,noselect"

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
-- vim.opt.relativenumber = false

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
vim.cmd("colorscheme grey")

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

vim.keymap.set("n", "<Leader>g", ":Neogit<CR>")

-- Formatter
vim.keymap.set({ "n", "v" }, "<Leader>fm", function()
  require("conform").format({
    async = true,
    lsp_fallback = true,
  })
end)

-- #373b41 greyish text fg
-- #81a2be light blue - default statusline color
local statusLineTheme = {
  normal = {
    a = { bg = "#f2f2f2", fg = "#000000" },
    b = { bg = "#f2f2f2", fg = "#000000" },
    c = { bg = "#f2f2f2", fg = "#000000" },
    z = { bg = "#f2f2f2", fg = "#000000" },
  },
  insert = {
    a = { bg = "#f2f2f2", fg = "#000000" },
    b = { bg = "#f2f2f2", fg = "#000000" },
    c = { bg = "#f2f2f2", fg = "#000000" },
    z = { bg = "#f2f2f2", fg = "#000000" },
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
    lualine_a = {},
    lualine_b = { "branch", "diff" },
    lualine_c = { "%=", { "filename", path = 1 } },
    lualine_x = { "diagnostics" },
    lualine_y = { "encoding", "filetype" },
    lualine_z = { "location" },
  },
  extensions = { "quickfix" },
})

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

-- terminal: disable line numbers and start in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
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

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<Leader>st", function()
  vim.cmd.new()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()

  vim.bo.filetype = "terminal"
end)

vim.api.nvim_set_hl(0, "String", { fg = '#1C7E08' })
