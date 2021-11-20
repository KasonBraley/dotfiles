local format = require("formatter")

local prettier = function()
  return {
    exe = "prettier_d_slim",
    args = { "--stdin", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
    stdin = true,
  }
end

format.setup({
  logging = false,
  filetype = {
    javascript = { prettier },
    javascriptreact = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    markdown = { prettier },
    css = { prettier },
    json = { prettier },
    jsonc = { prettier },
    yaml = { prettier },
    html = { prettier },
    lua = {
      -- stylua
      function()
        return {
          exe = "stylua",
          args = { "--config-path", "~/.config/.stylua.toml", "-" },
          stdin = true,
        }
      end,
    },
  },
})

-- format on save
-- vim.api.nvim_exec(
--   [[
-- augroup FormatAutogroup
--   autocmd!
--   autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.html,*css,*json,*lua FormatWrite
-- augroup END
-- ]],
--   true
-- )
