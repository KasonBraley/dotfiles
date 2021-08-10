local dap_install = require "dap-install"

dap_install.setup {
  installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
  verbosely_call_debuggers = false,
}

dap_install.config("jsnode_dbg", {
  adapters = {
    type = "executable",
    command = "node",
    args = { os.getenv "HOME" .. "/.local/share/nvim/dapinstall/jsnode_dbg/vscode-node-debug2/out/src/nodeDebug.js" },
  },
  configurations = {
    {
      type = "node2",
      request = "launch",
      program = "${workspaceFolder}/${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
  },
})
