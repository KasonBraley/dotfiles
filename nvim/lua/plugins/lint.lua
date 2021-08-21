-- local lint = require "lint"

-- lint.linters.eslint.args = {
--   "--config",
--   "~/.eslintrc.json",
-- }

-- lint.linters.eslint.cmd = "./node_modules/.bin/eslint"

-- lint.linters_by_ft = {
--   javascript = { "eslint" },
-- }
--
local null_ls = require "null-ls"

null_ls.config {
  sources = { null_ls.builtins.formatting.eslint },
}

require("lspconfig")["null-ls"].setup {}
