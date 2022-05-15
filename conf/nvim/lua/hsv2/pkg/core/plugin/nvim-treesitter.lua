local M = {}

function M.packer_spec(config)
    return {
        {
            'nvim-treesitter/nvim-treesitter',
            opt = true,
            config = function()
                require('nvim-treesitter.configs').setup({
                    highlight = {
                        enable = true,
                    }
                })
            end,
        },
    }
end

return M
