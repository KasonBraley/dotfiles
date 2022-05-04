local present, lualine = pcall(require, "lualine")
if not present then
  return
end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "solarized",
    component_separators = { "", "" },
    section_separators = { "", "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 }, "diagnostics", "diff" },
    lualine_x = { "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
