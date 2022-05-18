-- vi: et ts=4 sw=4
-- hsv2
return (function(_)
    local M = {}
    local _lua_module = 'indent_blankline'

    function M.packer_spec(config)
        return {
            {
                'lukas-reineke/indent-blankline.nvim',
                opt = true,
                requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
                config = function()
                    M.configure(config)
                end
            },
        }
    end

    function M.configure(config)
        vim.opt.list = true
        vim.opt.listchars:append('space:⋅')
        vim.opt.listchars:append("eol:↴")
        require(_lua_module).setup(config.plugin.opts)
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
