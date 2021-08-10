local execute = vim.api.nvim_command

local fn = vim.fn

-- Ensure Packer is installed
local packer_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(packer_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. packer_path)
  execute "packadd packer.nvim"
end

vim.cmd "packadd packer.nvim"
