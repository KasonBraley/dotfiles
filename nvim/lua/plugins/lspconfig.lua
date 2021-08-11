local lspconfig = require "lspconfig"
local lspinstall = require "lspinstall"

local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- lspInstall + lspconfig stuff

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()

  for _, lang in pairs(servers) do
    if lang ~= "lua" then
      lspconfig[lang].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
      }
    elseif lang == "lua" then
      lspconfig[lang].setup {
        root_dir = vim.loop.cwd,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = {
                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
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
      }
    end
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
  setup_servers() -- reload installed servers
  vim.cmd "bufdo e"
end
