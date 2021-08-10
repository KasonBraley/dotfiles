local format = require "formatter"

format.setup {
  logging = false,
  filetype = {
    javascript = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
    html = {
      -- html-beutify for better html indentation
      function()
        return {
          exe = "html-beautify",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
    css = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
    json = {
      -- prettierd
      function()
        return {
          exe = "prettierd",
          args = { vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
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
}

-- format on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.html,*css,*json,*lua FormatWrite
augroup END
]],
  true
)
