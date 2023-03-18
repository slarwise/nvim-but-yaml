local M = {}

M.read_config = function(config_path)
    local file = io.open(config_path, "rb") -- r read mode and b binary mode
    if not file then return end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    local config = vim.json.decode(content)
    return config
end

local config = M.read_config("nvim.json")
print(vim.inspect(config))

M.set_option = function(name, value)
    vim.o[name] = value
end

if not config then return end
local options = config.options

for name, value in pairs(options) do
    print(name, value)
    M.set_option(name, value)
end

local colorscheme = config.colorscheme
vim.cmd(string.format("colorscheme %s", colorscheme))

return M
