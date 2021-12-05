local my_modules = {
  "plugins",
  "options",
  "utils",
  "mappings",
  "packerInit",
}

for _, module in ipairs(my_modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
  end
end
