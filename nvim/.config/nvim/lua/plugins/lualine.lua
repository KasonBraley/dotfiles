return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      -- #373b41 greyish text fg
      -- #81a2be light blue - default statusline color
      local statusLineTheme = {
        normal = {
          a = { bg = "#f2f2f2", fg = "#000000" },
          b = { bg = "#f2f2f2", fg = "#000000" },
          c = { bg = "#f2f2f2", fg = "#000000" },
          z = { bg = "#f2f2f2", fg = "#000000" },
        },
        insert = {
          a = { bg = "#f2f2f2", fg = "#000000" },
          b = { bg = "#f2f2f2", fg = "#000000" },
          c = { bg = "#f2f2f2", fg = "#000000" },
          z = { bg = "#f2f2f2", fg = "#000000" },
        },
      }

      local opts = {
        options = {
          icons_enabled = false,
          theme = statusLineTheme,
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
