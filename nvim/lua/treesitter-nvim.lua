local M = {}

M.config = function()
  local ts_config = require("nvim-treesitter.configs")

  ts_config.setup {
    ensure_installed = {
      "javascript",
      "html",
      "css",
      "typescript",
      "tsx",
      "json",
      "bash",
      "lua",
      "python"
      -- "rust",
      -- "go"
    },
    highlight = {
      enable = true,
      use_languagetree = true
    }
  }
end

return M
