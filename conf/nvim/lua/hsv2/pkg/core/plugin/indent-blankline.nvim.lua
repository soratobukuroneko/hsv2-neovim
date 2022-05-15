-- vi: et ts=4 sw=4
-- hsv2
local M = {}

function M.packer_spec(config)
    return {
        {
            'lukas-reineke/indent-blankline.nvim',
            opt = true,
            requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
            config = function(name, _)
                vim.opt.list = true
                vim.opt.listchars:append('space:⋅')
                vim.opt.listchars:append("eol:↴")
                require(name).setup {
                    use_treesitter = true,
                    show_end_of_line = true,
                    space_char_blankline = ' ',
                    show_current_context = true,
                    show_current_context_start = true,
                }
            end
        },
    }
end

return M
