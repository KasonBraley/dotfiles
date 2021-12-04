local M = {}

-- Auto-install
local lsp_installer_servers = require("nvim-lsp-installer.servers")

local ok, yaml = lsp_installer_servers.get_server("yamlls")
if ok then
  if not yaml:is_installed() then
    yaml:install()
  end
end

-- Settings
M.settings = {
  yaml = {
    -- Schemas https://www.schemastore.org
    schemas = {
      ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
    },
  },
}

return M
