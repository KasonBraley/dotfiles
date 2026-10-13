return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local opts = {
        options = {
          icons_enabled = false,
          theme = function()
            return require("terminal_theme").lualine()
          end,
          component_separators = { "", "" },
          section_separators = { "", "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = {},
          lualine_b = { "branch", "diff" },
          lualine_c = { "%=", { "filename", path = 1 } },
          lualine_x = { "diagnostics" },
          lualine_y = { "encoding", "filetype" },
          lualine_z = { "location" },
        },
        extensions = { "quickfix" },
      }

      return opts
    end,
  },
}
