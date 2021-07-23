require "options"

local my_modules = {
  "pluginList",
  "mappings",
  "utils"
}

local async
async =
  vim.loop.new_async(
  vim.schedule_wrap(
    function()
      for i = 1, #my_modules, 1 do
        pcall(require, my_modules[i])
      end
      async:close()
    end
  )
)
async:send()
