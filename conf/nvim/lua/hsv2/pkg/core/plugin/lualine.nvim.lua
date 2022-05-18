-- vi: et ts=4 sw=4:
-- hsv2
return (function(_)
    local M = {}
    local _lua_module = 'lualine'

    function M.packer_spec(config)
        return {
            {
                'nvim-lualine/lualine.nvim',
                opt = true,
                requires = { 'kyazdani42/nvim-web-devicons', opt = true },
                config = function()
                    M.configure(config)
                end,
            },
        }
    end

    function M.configure(config)
        if config.plugin.opts.options.icons_enabled == nil then
            config.plugin.opts.options.icons_enabled = config.hsv2.fancy_font
        end
        require(_lua_module).setup(config.plugin.opts)
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
