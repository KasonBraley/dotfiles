local M = {}

M.colorizer = function()
  require("colorizer").setup()
end

M.neoscroll = function()
  require("neoscroll").setup({
    mappings = { "<C-u>", "<C-d>" },
  })
  local t = {}
  t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
  t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
  require("neoscroll.config").set_mappings(t)
end

M.blankline = function()
  vim.g.indentLine_enabled = 1
  vim.g.indent_blankline_char = "▏"

  vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard", "packer" }
  vim.g.indent_blankline_buftype_exclude = { "terminal" }

  vim.g.indent_blankline_show_trailing_blankline_indent = false
  vim.g.indent_blankline_show_first_indent_level = false
end

-- custom telescope search functions
M.search_dev = function()
  require("telescope.builtin").find_files({
    prompt_title = "~ dev ~ ",
    shorten_path = false,
    hidden = true,
    cwd = "~/dev/",
    layout_strategy = "bottom_pane",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.5,
      height = 0.5,
      preview_cutoff = 10,
    },
  })
end

M.search_dotfiles = function()
  require("telescope.builtin").git_files({
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    hidden = true,
    cwd = "~/dotfiles",
    file_ignore_patterns = {
      "*.png",
      "*.jpg",
      "node_modules/*",
      "dist/*",
    },
    layout_strategy = "bottom_pane",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.5,
      height = 0.5,
      preview_cutoff = 10,
    },
  })
end

-- toggle cmp completion
vim.g.cmp_toggle_flag = false -- initialize
local normal_buftype = function()
  return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
end
M.toggle_completion = function()
  local ok, cmp = pcall(require, "cmp")
  if ok then
    local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
    if next_cmp_toggle_flag then
      print("completion on")
    else
      print("completion off")
    end
    cmp.setup({
      enabled = function()
        vim.g.cmp_toggle_flag = next_cmp_toggle_flag
        if next_cmp_toggle_flag then
          return normal_buftype
        else
          return next_cmp_toggle_flag
        end
      end,
    })
  else
    print("completion not available")
  end
end

return M
