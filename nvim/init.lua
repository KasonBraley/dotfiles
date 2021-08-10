local my_modules = {
  "options",
  "utils",
  "plugins",
  "mappings",
  "packerInit",
}

for i = 1, #my_modules, 1 do
  pcall(require, my_modules[i])
end
