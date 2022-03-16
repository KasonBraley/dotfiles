local present, format = pcall(require, "formatter")
if not present then
  return
end

local prettier = function()
  return {
    exe = "prettier",
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
    go = {
      function()
        return {
          exe = "goimports",
          args = { "-w", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
          stdin = false,
        }
      end,
    },
    lua = {
      -- stylua
      function()
        return {
          exe = "stylua",
          args = { "--indent-type", "spaces", "--indent-width", "2", "-" },
          stdin = true,
        }
      end,
    },
    sh = {
      -- Shell Script Formatter
      function()
        return {
          exe = "shfmt",
          -- args = { "-i", 2 },
          stdin = true,
        }
      end,
    },
  },
})
