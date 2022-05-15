-- vi: et ts=4 sw=4:
-- hsv2
local M = {}

function M.packer_spec(config)
    return {
        {
            'nvim-lualine/lualine.nvim',
            opt = true,
            requires = { 'kyazdani42/nvim-web-devicons', opt = true },
            config = function(name, _)
                require(name).setup({
                    sections = {
                        lualine_a = { { 'mode', fmt = function(str)
                            return str:sub(1, 1)
                        end } },
                        lualine_b = {
                            'g:coc_status',
                            'branch',
                            'diff',
                            {
                                'diagnostics',
                                sources = { 'coc' }
                            },
                            'filetype' },
                        lualine_c = {
                            { 'filename', path = 1 },
                        }
                    },
                    tabline = {
                        lualine_a = {
                            { 'tabs', max_length = vim.o.columns, mode = 2 },
                        },
                    },
                    options = {
                        globalstatus = true,
                        icons_enabled = config.use_icons,
                    },
                    extensions = {
                        'fugitive',
                        'quickfix',
                    }
                })
            end,
        },
    }
end

return M
