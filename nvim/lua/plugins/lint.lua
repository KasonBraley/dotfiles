local lint = require "lint"

lint.linters.eslint.cmd = "./node_modules/.bin/eslint"

lint.linters_by_ft = {
  javascript = { "eslint" },
  javascriptreact = { "eslint" },
}
