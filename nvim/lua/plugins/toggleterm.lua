local M = {}

M.config = function()
  -- vim.cmd [[packadd nvim-toggleterm.lua]]
  local toggleterm = require("toggleterm")

  toggleterm.setup(
    {
      size = 10,
      open_mapping = "<C-x>",
      -- shade_filetypes = {},
      shade_terminals = true,
      shading_factor = "1",
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
      hide_numbers = true,
      close_on_exit = true
    }
  )
end

return M
