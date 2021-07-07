require("formatter").setup(
  {
    logging = false,
    filetype = {
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
      },
      html = {
        -- prettier
        function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
      },
      css = {
        -- prettier
        function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd FileType javascript autocmd BufWritePost <buffer> FormatWrite
  autocmd FileType html autocmd BufWritePost <buffer> FormatWrite
  autocmd FileType css autocmd BufWritePost <buffer> FormatWrite
  autocmd FileType lua autocmd BufWritePost <buffer> FormatWrite
  autocmd FileType typescript autocmd BufWritePost <buffer> FormatWrite
augroup end
]],
  true
)

local opt = {noremap = true, silent = true}

vim.api.nvim_set_keymap("n", "<Leader>fm", [[<Cmd> Format<CR>]], opt)
