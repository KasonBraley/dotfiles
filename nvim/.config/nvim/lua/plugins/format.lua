local present, format = pcall(require, "formatter")
if not present then
  return
end

local prettier = function()
  return {
    exe = "./node_modules/.bin/prettier",
    args = { "--stdin", "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
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
          args = { "-w", vim.api.nvim_buf_get_name(0) },
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
  },
})
