local M = {}

M.colorizer = function()
  require("colorizer").setup()
end

M.lspkind = function()
  require("lspkind").init()
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
    layout_strategy = "horizontal",
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
    cwd = "~/dotfiles/nvim",
    layout_strategy = "horizontal",
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

local function refactor(prompt_bufnr)
  local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
  require("telescope.actions").close(prompt_bufnr)
  require("refactoring").refactor(content.value)
end
-- NOTE: M is a global object
-- for the sake of simplicity in this example
-- you can extract this function and the helper above
-- and then require the file and call the extracted function
-- in the mappings below

M.refactors = function()
  local opts = require("telescope.themes").get_cursor() -- set personal telescope options
  require("telescope.pickers").new(opts, {
    prompt_title = "refactors",
    finder = require("telescope.finders").new_table {
      results = require("refactoring").get_refactors(),
    },
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<CR>", refactor)
      map("n", "<CR>", refactor)
      return true
    end,
  }):find()
end

return M
