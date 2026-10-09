local cwd = rex.args.cwd
if type(cwd) ~= "string" or cwd == "" then error("cwd is required", 0) end

local shell = "com.superlogical.terminal.shell"

local w, err = rex.session.new_window{
  window_label = rex.args.label,
  layout = rex.layout.vertical(rex.args.ratio or 0.7,
    rex.layout.block{
      flavor  = shell,
      label   = "pi",
      options = { cwd = cwd, initial_input = "pi\n" },
    },
    rex.layout.block{
      flavor  = shell,
      label   = "shell",
      options = { cwd = cwd },
    }),
}
if err ~= nil then error(err, 0) end

local pi = w.block_ids[1]
local _, ferr = rex.session.focus_block{ block_id = pi }
if ferr ~= nil then error(ferr, 0) end

return { window_id = w.window_id, block_id = pi }
