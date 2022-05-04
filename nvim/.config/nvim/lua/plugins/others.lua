local M = {}

-- custom telescope search functions
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

M.goimports = function(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.formatting_sync()
end

return M
