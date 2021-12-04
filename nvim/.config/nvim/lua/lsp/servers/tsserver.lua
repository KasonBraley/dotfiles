local M = {}

-- Auto-install
local lsp_installer_servers = require("nvim-lsp-installer.servers")

local ok, tsserver = lsp_installer_servers.get_server("tsserver")
if ok then
  if not tsserver:is_installed() then
    tsserver:install()
  end
end

-- Settings

M.handlers = {
  -- disable tsserver diagnostics
  ["textDocument/publishDiagnostics"] = function() end,
}

return M
