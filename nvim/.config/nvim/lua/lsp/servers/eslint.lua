local M = {}

-- Auto-install

local lsp_installer_servers = require("nvim-lsp-installer.servers")

local ok, eslint = lsp_installer_servers.get_server("eslint")
if ok then
  if not eslint:is_installed() then
    eslint:install()
  end
end

-- Settings

M.filetypes = {
  -- disable eslint diagnotics for .js files, instead it is handled by quick_lint_js
  -- "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
  "vue",
}

return M
