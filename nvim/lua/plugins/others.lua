local M = {}

M.colorizer = function()
  require("colorizer").setup()
end

M.neoscroll = function()
  require("neoscroll").setup {
    mappings = { "<C-u>", "<C-d>" },
  }
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
  require("telescope.builtin").find_files {
    prompt_title = "~ dev ~ ",
    shorten_path = false,
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
      width = 0.87,
      height = 0.60,
      preview_cutoff = 120,
    },
  }
end

M.search_dotfiles = function()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~ ",
    shorten_path = false,
    hidden = true,
    cwd = "~/dotfiles",
    file_ignore_patterns = {
      ".git/*",
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
      width = 0.87,
      height = 0.60,
      preview_cutoff = 120,
    },
  }
end

return M
