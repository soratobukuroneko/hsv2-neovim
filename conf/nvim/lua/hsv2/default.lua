-- vi: et sw=4 ts=4:
-- hsv2
local M = {}

M.hsv2 = {
    -- Enable features for 42 specific needs.
    flavour42 = {
        is_enabled = true,
        username = 'changeme',
        email = 'changeme',
    },
    -- Browse - Repositories searches in the following directories
    repo_dirs = {
        '~',
    },
    -- Browse - Find Files search directories
    find_files_dirs = {
        '~',
    },
    -- Key mapping prefix
    leader = ' ',
    -- not used
    local_leader = ',',
    -- icons, italic and such
    fancy_font = false,
    post_sync_script = 'lua/post_sync.lua',
    theme = 'neon'
}

M.packages = {}
M.packages.core = {
    enabled = true,
    plugins = {
        ['vim-rooter'] = {
            enabled = true,
            vim_globals = {
                change_directory_for_non_project_files = 'current',
                cd_cmd = 'lcd',
            },
        },
        ['suda.vim'] = {
            enabled = true,
            vim_globals = {
                smart_edit = true,
            },
        },
        ['lualine.nvim'] = {
            enabled = true,
            opts = {
                sections = {
                    lualine_a = { { 'mode', fmt = function(str)
                        return str:sub(1, 1)
                    end } },
                    lualine_b = {
                        'g:coc_status',
                        'branch',
                        'diff',
                        -- TODO: make this section detect availability of
                        -- coc
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
                    --icons_enabled = config.use_icons,
                },
                extensions = {
                    'fugitive',
                    'quickfix',
                }
            },
        }
    },
    ['nvim-treesitter'] = {
        enable = true,
        opts = {
            highlight = {
                enable = true,
            },
        },
    },
    ['indent-blankline.nvim'] = {
        enable = true,
        opts = {
            use_treesitter = true,
            show_end_of_line = true,
            space_char_blankline = ' ',
            show_current_context = true,
            show_current_context_start = true,
        }
    },
    ['auto-session'] = {
        enabled = true,
    },
    ['gentoo-syntax'] = {
        enabled = false,
    },
}

M.themes = {
    neon = {
        enabled = true,
    },
}

M.packer = {
    --disable_commands = true,
    display = {
        open_fn = require('packer.util').float,
    },
    autoremove = true,
}

return M
