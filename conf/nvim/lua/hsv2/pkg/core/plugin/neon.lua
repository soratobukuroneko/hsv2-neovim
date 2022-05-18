local M = {}

function M.packer_spec(config)
    return {
        {
            'rafamadriz/neon',
            config = function(name, _)
                vim.g.neon_bold = config.enable_bold
                vim.g.neon_italic_boolean = config.italic_boolean
                vim.g.neon_italic_function = config.italic_function
                vim.g.neon_italic_keyword = config.italic_keyword
                vim.g.neon_italic_variable = config.italic_variable
                if config.theme == name then
                    vim.api.nvim_exec('colorscheme ' .. name, false)
                end
            end
        },
    }
end

return M
