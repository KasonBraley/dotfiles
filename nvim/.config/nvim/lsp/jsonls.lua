---@brief
---
--- https://github.com/hrsh7th/vscode-langservers-extracted
---
--- vscode-json-language-server, a language server for JSON and JSON schema
---
--- `vscode-json-language-server` can be installed via `npm`:
--- ```sh
--- npm i -g vscode-langservers-extracted
--- ```
---
--- `vscode-json-language-server` only provides completions when snippet support is enabled. If you use Neovim older than v0.10 you need to enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.
---
--- ```lua
--- --Enable (broadcasting) snippet capability for completion
--- local capabilities = vim.lsp.protocol.make_client_capabilities()
--- capabilities.textDocument.completion.completionItem.snippetSupport = true
---
--- vim.lsp.config('jsonls', {
---   capabilities = capabilities,
--- })
--- ```
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },
  root_markers = { '.git' },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { "composer.json" },
          url =
          "https://raw.githubusercontent.com/composer/composer/main/res/composer-schema.json",
        },
      },
    },
  },
}
