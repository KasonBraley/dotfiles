local present, lsp_installer = pcall(require, "nvim-lsp-installer")
if not present then
  return
end

local servers = {
  "tsserver",
  "jsonls",
  "sumneko_lua",
  "jsonls",
  "yamlls",
  "html",
  "cssls",
  "tailwindcss",
  "eslint",
  "dockerls",
  "gopls",
  "quick_lint_js",
  "bashls",
  "intelephense",
}

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
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  return {
    capabilities = capabilities,
    root_dir = vim.loop.cwd,
  }
end

-- lspInstall + lspconfig stuff

lsp_installer.on_server_ready(function(server)
  local config = make_config()
  local default_opts = {
    on_attach = on_attach,
    capabilities = config.capabilities,
  }

  -- Now we'll create a server_opts table where we'll specify our custom LSP server configuration
  local server_opts = {
    ["sumneko_lua"] = function()
      default_opts.settings = require("lsp.servers.lua").settings
      return default_opts
    end,
    ["tsserver"] = function()
      default_opts.single_file_support = require("lsp.servers.tsserver").single_file_support
      default_opts.handlers = require("lsp.servers.tsserver").handlers
      return default_opts
    end,
    ["eslint"] = function()
      default_opts.filetypes = require("lsp.servers.eslint").filetypes
    end,
    ["jsonls"] = function()
      default_opts.settings = require("lsp.servers.json").settings
      return default_opts
    end,
    ["yamlls"] = function()
      default_opts.settings = require("lsp.servers.yaml").settings
      return default_opts
    end,
    -- ["gopls"] = function()
    --   default_opts.on_attach = function(client, bufnr)
    --     local function buf_set_keymap(...)
    --       vim.api.nvim_buf_set_keymap(bufnr, ...)
    --     end
    --
    --     vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    --     local opts = { noremap = true, silent = false }
    --
    --     if client.resolved_capabilities.document_formatting then
    --       buf_set_keymap("n", "fa", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    --     elseif client.resolved_capabilities.document_range_formatting then
    --       buf_set_keymap("n", "fa", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    --       return default_opts.on_attach
    --     end
    --   end
    -- end,
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
