local root = rex.args.path
if type(root) ~= "string" or root == "" then error("path is required", 0) end
root = root:gsub("/+$", "")

local function inside(dir)
  return dir == root or dir:sub(1, #root + 1) == root .. "/"
end

local function cwd(session_id, block_id)
  local p = rex.call("block.method", {
    session_id = session_id,
    block_id   = block_id,
    method     = "process",
    args       = {},
  })
  return p and p.foreground and p.foreground.cwd
end

local list, err = rex.call("session.list")
if err ~= nil then error(err, 0) end

local found, current = {}, nil
for _, s in ipairs(list.sessions or {}) do
  local view = rex.call("session.view", { session_id = s.session_id })
  for _, w in ipairs(view and view.windows or {}) do
    local count, matched, mine = 0, true, false
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        count = count + 1
        if b.block_id == rex.block_id then mine = true end
        if matched then
          local dir = cwd(s.session_id, b.block_id)
          matched = dir ~= nil and inside(dir)
        end
      end
    end
    if matched and count > 0 then
      local entry = { session_id = s.session_id, window_id = w.window_id, label = w.label }
      if mine then current = entry else found[#found + 1] = entry end
    end
  end
end
if current then found[#found + 1] = current end

return { windows = found }
