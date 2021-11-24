local lsp_installer = require("nvim-lsp-installer")

require("lspconfig/quick_lint_js").setup({})

local servers = {
  "tsserver",
  "pyright",
  "jsonls",
  "sumneko_lua",
  "jsonls",
  "yamlls",
  "html",
  "cssls",
  "tailwindcss",
  "clangd",
  "eslint",
  "dockerls",
}

local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local lsp = vim.lsp

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  signs = true,
  virtual_text = false,
  update_in_insert = true,
})

-- Capture real implementation of function that sets signs
local orig_set_signs = lsp.diagnostic.set_signs
local set_signs_limited = function(diagnostics, bufnr, client_id, sign_ns, opts)
  -- original func runs some checks, which I think is worth doing
  -- but maybe overkill
  if not diagnostics then
    diagnostics = diagnostic_cache[bufnr][client_id]
  end

  -- early escape
  if not diagnostics then
    return
  end

  -- Work out max severity diagnostic per line
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    if max_severity_per_line[d.range.start.line] then
      local current_d = max_severity_per_line[d.range.start.line]
      if d.severity < current_d.severity then
        max_severity_per_line[d.range.start.line] = d
      end
    else
      max_severity_per_line[d.range.start.line] = d
    end
  end

  -- map to list
  local filtered_diagnostics = {}
  for i, v in pairs(max_severity_per_line) do
    table.insert(filtered_diagnostics, v)
  end

  -- call original function
  orig_set_signs(filtered_diagnostics, bufnr, client_id, sign_ns, opts)
end
lsp.diagnostic.set_signs = set_signs_limited

-- Configure lua language server for neovim development
local lua_settings = {
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
}

local json_settings = {
  json = {
    -- Schemas https://www.schemastore.org
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
        fileMatch = {
          ".prettierrc",
          ".prettierrc.json",
          "prettier.config.json",
        },
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
}

local yaml_settings = {
  yaml = {
    -- Schemas https://www.schemastore.org
    schemas = {
      ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
    },
  },
}

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  return {
    capabilities = capabilities,
    on_attach = on_attach(),
    root_dir = vim.loop.cwd,
  }
end

-- lspInstall + lspconfig stuff

lsp_installer.on_server_ready(function(server)
  local config = make_config()
  local default_opts = {
    on_attach = config.on_attach,
    capabilities = config.capabilities,
  }

  -- Now we'll create a server_opts table where we'll specify our custom LSP server configuration
  local server_opts = {
    ["sumneko_lua"] = function()
      default_opts.settings = lua_settings

      return default_opts
    end,
    ["tsserver"] = function()
      default_opts.handlers = {
        -- disable tsserver diagnostics
        ["textDocument/publishDiagnostics"] = function() end,
      }
      return default_opts
    end,
    ["eslint"] = function()
      default_opts.filetypes = {
        -- disable eslint diagnotics for .js files, instead it is handled by quick_lint_js
        -- "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      }
    end,
    ["jsonls"] = function()
      default_opts.settings = json_settings
      return default_opts
    end,
    ["yamlls"] = function()
      default_opts.settings = yaml_settings
      return default_opts
    end,
  }

  -- We check to see if any custom server_opts exist for the LSP server, if so, load them, if not, use our default_opts
  server:setup(server_opts[server.name] and server_opts[server.name]() or default_opts)
  vim.cmd([[ do User LspAttachBuffers ]])
end)

for _, name in pairs(servers) do
  local ok, server = lsp_installer.get_server(name)
  -- Check that the server is supported in nvim-lsp-installer
  if ok then
    if not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end
