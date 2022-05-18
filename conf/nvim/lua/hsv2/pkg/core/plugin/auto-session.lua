-- vi: et ts=4 sw=4:
-- hsv2
return (function()
    local M = {}
    local _lua_module = 'auto-session'

    function M.packer_spec(config)
        return {
            {
                'rmagatti/auto-session',
                opt = true,
                config = function(name, _)
                end,
            },
        }
    end

    function M.configure(config)
        require(_lua_module).setup(config.plugin.opts)
        for _, opt in ipairs({
            'blank',
            'buffers',
            'curdir',
            'folds',
            'help',
            'tabpages',
            'winsize',
            'winpos',
            'terminal',
        }) do
            vim.opt.sessionoptions:append(opt)
        end
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
