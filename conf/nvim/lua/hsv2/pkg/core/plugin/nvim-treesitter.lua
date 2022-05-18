-- vi: et sw=4 ts=4:
-- hsv2
return (function(_)
    local M = {}

    function M.packer_spec(config)
        return {
            {
                'nvim-treesitter/nvim-treesitter',
                opt = true,
                config = function()
                    M.configure(config)
                end,
            },
        }
    end

    function M.configure(config)
        require('nvim-treesitter.configs').setup(config.plugin.opts)
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
