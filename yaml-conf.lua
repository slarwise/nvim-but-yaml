local yaml = require('yaml')

local f = assert(io.open("nvim.yaml", "r"))
local content = f:read("*a")
f:close()

local function set_option(name, value)
    print("Would set", name, "to", value)
end

local function main()
    local configuration = yaml.eval(content)
    for k, v in pairs(configuration.options) do
        set_option(k, v)
    end
end

main()
