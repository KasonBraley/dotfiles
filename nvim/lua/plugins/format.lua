local present, format = pcall(require, "formatter")
if not present then
  return
end

format.setup(
  {
    logging = false,
    filetype = {
      javascript = {
        -- prettierd
        function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
      },
      html = {
        -- html-beutify for better html indentation
        function()
          return {
            exe = "html-beautify",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
      },
      css = {
        -- prettierd
        function()
          return {
            exe = "prettierd",
            args = {vim.api.nvim_buf_get_name(0)},
            stdin = true
          }
        end
      },
      json = {
        -- prettierd
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

-- format on save
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
