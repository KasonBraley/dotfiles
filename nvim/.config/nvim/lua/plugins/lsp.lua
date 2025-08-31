return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
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
          vim.keymap.set("n", "grd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
          vim.keymap.set("n", "grr", require("telescope.builtin").lsp_references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, opts)
          vim.keymap.set("n", "S", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
          local code_action_fn = function()
            -- TODO: detect if we are in a Go buffer, otherwise don't do this.
            -- https://github.com/laurazard/dot-nvim/blob/a0905267f9b60b305a1c0f96ef46f4c9da0da4bc/lua/lib/lsp_utils.lua#L4
            opts = {
              context = {
                only = {
                  -- https://github.com/golang/tools/blob/master/gopls/doc/features/transformation.md#code-actions
                  "source.doc",
                  -- "gopls.doc.feature", -- this one is responsible for the "browse gopls documentation" action
                  "source.fixAll",
                  "source.freesymbols",
                  "source.organizeImports",
                  "source.toggleCompilerOptDetails",
                  "source.addTest",
                  "quickfix",
                  "refactor",
                }
              }
            }
            vim.lsp.buf.code_action(opts)
          end
          vim.keymap.set({ "n", "v" }, "<space>ca", code_action_fn, opts)
          vim.keymap.set({ "n", "v" }, "gra", code_action_fn, opts)
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

          vim.keymap.set("i", "<C-CR>", function()
            if not vim.lsp.inline_completion.get() then
              return "<C-CR>"
            end
          end, {
            expr = true,
            replace_keycodes = true,
            desc = "Get the current inline completion",
          })

          local function toggle_copilot()
            if vim.lsp.inline_completion.is_enabled() then
              vim.lsp.inline_completion.enable(false)
              vim.notify('Copilot disabled')
            else
              vim.lsp.inline_completion.enable(true)
              vim.notify('Copilot enabled')
            end
          end

          vim.api.nvim_create_user_command('CopilotToggle', toggle_copilot, {})
          vim.keymap.set("n", "<Leader>ta", ":CopilotToggle<CR>", { noremap = true, silent = true })
        end
      })

      -- config that activates keymaps and enables snippet support
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities,
        require('cmp_nvim_lsp').default_capabilities())

      vim.lsp.config("*", { capabilities = capabilities })

      -- vim.lsp.config["clangd"] = {
      --   cmd = { 'clangd', '--clang-tidy' },
      --   root_markers = { '.clangd', 'compile_commands.json' },
      --   filetypes = { 'c', 'cpp' },
      -- }

      vim.lsp.enable({
        "bashls",
        "clangd",
        "copilot",
        "cssls",
        "dockerls",
        "gopls",
        "html",
        "intelephense",
        "ruff",
        "pyright",
        "jsonls",
        "lua_ls",
        -- "terraformls",
        "ts_ls",
        "yamlls",
      })
    end
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
      local registry = require "mason-registry"

      local packages = {
        "bash-language-server",
        "clangd",
        "css-lsp",
        "dockerfile-language-server",
        "gopls",
        "html-lsp",
        "intelephense",
        "json-lsp",
        "lua-language-server",
        -- "terraform-ls",
        "typescript-language-server",
        "yaml-language-server",
      }

      registry.refresh(function()
        for _, pkg_name in ipairs(packages) do
          local pkg = registry.get_package(pkg_name)
          if not pkg:is_installed() then
            vim.notify(
              string.format("Installing %s...", pkg.name),
              vim.log.levels.INFO,
              { title = "Mason" }
            )
            pkg:install()
          end
        end
      end)
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },

  -- { "mfussenegger/nvim-jdtls" },

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

}
