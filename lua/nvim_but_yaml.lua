local M = {}

local read_config = function(config_path)
    assert(io.open(config_path, "r"))
    local handle = io.popen(string.format("yq . %s", config_path))
    local output = handle:read("*a")
    handle:close()
    return vim.json.decode(output)
end

local set_option = function(name, value)
    vim.o[name] = value
end

local set_colorscheme = function(colorscheme)
    vim.cmd(string.format("colorscheme %s", colorscheme))
end

local create_mapping = function(mode, lhs, rhs)
    if type(rhs) == "string" then
        vim.keymap.set(mode, lhs, rhs)
    else
        vim.keymap.set(mode, lhs, loadstring(rhs.callback), { expr = rhs.expr })
    end
end

local set_global_variable = function(variable, value)
    vim.g[variable] = value
end

local set_autocmd = function(event, pattern, command)
    vim.api.nvim_create_autocmd(event, {
        pattern = pattern,
        command = command,
    })
end

local create_command = function(name, callback)
    vim.api.nvim_create_user_command(name, callback, {})
end

local set_language_server_mapping = function(mode, lhs, rhs)
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf })
        end
    })
end

local override_language_server_handler = function(handler, config)
    vim.lsp.handlers[handler] = vim.lsp.with(vim.lsp.handlers[handler], config)
end

local set_filetype_option = function(filetype, name, value)
    vim.api.nvim_create_autocmd('Filetype', {
        pattern = filetype,
        callback = function() vim.opt_local[name] = value end
    })
end

local set_diagnostics = function(opts)
    vim.diagnostic.config(opts)
end

local set_highlight_link = function(from, to)
    vim.api.nvim_set_hl(0, from, { link = to })
end

local set_language_server_for_filetype = function(filetype, config)
    vim.api.nvim_create_autocmd('Filetype', {
        pattern = filetype,
        callback = function()
            local root_dir = vim.fs.dirname(vim.fs.find(config.root_dir.patterns, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1])
            vim.lsp.start({
                name = config.name,
                cmd = config.cmd,
                root_dir = root_dir,
                settings = config.settings,
                on_attach = function(client, bufnr)
                    client.server_capabilities = vim.tbl_extend("force", client.server_capabilities, config.server_capabilities or {})
                end,
            })
        end
    })
end

local add_filetype_mappings = function(filetypes)
  vim.filetype.add(filetypes)
end

M.apply = function(config_file_path)
    if vim.fn.executable("yq") == 0 then
        vim.notify("nvim_but_yaml: yq is not an executable command, ensure this is installed", vim.log.levels.ERROR)
        return
    end

    local config = read_config(config_file_path)
    if not config then return end

    if config.options then
        for name, value in pairs(config.options) do
            set_option(name, value)
        end
    end

    if config.variables then
      for name, value in pairs(config.variables) do
        vim.g[name] = value
      end
    end

    if config.colorscheme then
        set_colorscheme(config.colorscheme)
    end

    if config.mappings then
        if config.mappings.normal then
            for lhs, rhs in pairs(config.mappings.normal) do
                create_mapping('n', lhs, rhs)
            end
        end
        if config.mappings.command then
            for lhs, rhs in pairs(config.mappings.command) do
                create_mapping('c', lhs, rhs)
            end
        end
        if config.mappings.terminal then
            for lhs, rhs in pairs(config.mappings.terminal) do
                create_mapping('t', lhs, rhs)
            end
        end
    end

    if config.autocmds then
        for event, opts in pairs(config.autocmds) do
            set_autocmd(event, opts.pattern, opts.command)
        end
    end

    if config.commands then
        for name, callback in pairs(config.commands) do
            create_command(name, loadstring(callback))
        end
    end

    if config.language_server then
        if config.language_server.mappings then
            if config.language_server.mappings.normal then
                for lhs, rhs in pairs(config.language_server.mappings.normal) do
                    set_language_server_mapping('n', lhs, rhs)
                end
            end
        end
        if config.language_server.handlers then
            for handler, settings in pairs(config.language_server.handlers) do
                override_language_server_handler(handler, settings)
            end
        end
    end

    if config.diagnostics then
        set_diagnostics(config.diagnostics)
    end

    if config.syntax then
        if config.syntax.highlight_links then
            for from, to in pairs(config.syntax.highlight_links) do
                set_highlight_link(from, to)
            end
        end
    end

    if config.filetypes then
        for filetype, settings in pairs(config.filetypes) do
            if settings.options then
                for name, value in pairs(settings.options) do
                    set_filetype_option(filetype, name, value)
                end
            end
            if settings.language_server then
                set_language_server_for_filetype(filetype, settings.language_server)
            end
        end
    end

    if config.filetype_mappings then
      add_filetype_mappings(config.filetype_mappings)
    end
end

return M
