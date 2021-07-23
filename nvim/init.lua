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
        local ok, res = xpcall(require, debug.traceback, my_modules[i])
        if not (ok) then
          print("Error loading module : " .. my_modules[i])
          print(res) -- print stack traceback of the error
        end
      end
      async:close()
    end
  )
)
async:send()
