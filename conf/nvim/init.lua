-- vi: et sw=4 ts=4
-- hsv-2
--
CONF = {
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
    -- Use devicons and so on. Require a patched Font
    use_icons = true,
}

local pkgs = {
    'wbthomason/packer.nvim',
    'nvim-treesitter/nvim-treesitter',
    'soratobukuroneko/sqlite.lua', -- needed by some plugins
    'gentoo/gentoo-syntax',
    'sheerun/vim-polyglot',
    'folke/which-key.nvim',
    {
        'neoclide/coc.nvim',
        run = 'npm install &> npm.log'
    },
    'rafcamlet/coc-nvim-lua',
    'tpope/vim-fugitive',
    'lewis6991/gitsigns.nvim',
    'lukas-reineke/indent-blankline.nvim',
    'kyazdani42/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'AckslD/nvim-neoclip.lua',
    'airblade/vim-rooter',
    'lambdalisue/suda.vim',
    {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
    },
    'nvim-telescope/telescope-packer.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'cljoly/telescope-repo.nvim',
    'rmagatti/auto-session',
    {
        'rmagatti/session-lens',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        after = 'plenary.nvim',
    },
    'rafamadriz/neon', -- theme
    'numToStr/Comment.nvim',
    'numToStr/FTerm.nvim',
    {
        'ellisonleao/glow.nvim',
        ft = 'markdown'
    }
}
if CONF.flavour42.is_enabled then
    table.insert(pkgs, '42Paris/42header')
    table.insert(pkgs, 'cacharle/c_formatter_42.vim')
end

UTILS = require('hsv2_utils')

----- Core ------
vim.g.mapleader = CONF.leader
vim.g.localleader = CONF.local_leader
vim.keymap.set(
    { 'n', 'v' },
    '<Space>',
    '<Nop>'
)
PLUGINS = {}
PLUGINS.has_packer, PLUGINS.packer = pcall(require, 'packer')
local function get_conf()
    return {
        pkgs,
        config = {
            display = {
                open_fn = require('packer.util').float,
            }
        }
    }
end
if not PLUGINS.has_packer then
    require('bootstrap').bootstrap_packer(get_conf)
else
    PLUGINS.packer.startup(get_conf())
    vim.keymap.set('n', '<Leader>vu', function()
        UTILS.hsv2_conf_update('lua/post_sync.lua')
    end, {
        desc = 'Config Update',
    })
end
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = '80'
vim.opt.completeopt = 'menuone,noselect,preview'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.modeline = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.signcolumn = 'yes'
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 80
vim.opt.undofile = true
vim.g.vimsyn_embed = 'l'
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
    end
})
vim.keymap.set('n', '<Leader>vc', function()
    vim.cmd('edit $MYVIMRC')
end, {
    desc = 'Edit Config',
})
vim.keymap.set('n', '<Leader>aq', function()
    local wins = 0
    for _ in ipairs(vim.api.nvim_list_wins()) do
        wins = wins + 1
    end
    if wins > 1 then
        vim.api.nvim_win_close(0, false)
    else
        vim.api.nvim_exec('quit', false)
    end
end, {
    desc = 'Close Window',
})
vim.keymap.set('n', '<Leader>aQ', function()
    vim.cmd('wqa')
end, {
    desc = 'Save and Exit',
})
vim.keymap.set('n', '<Leader>ah', function()
    vim.cmd('nohlsearch')
end, {
    desc = 'Disable Search Highlight',
})
vim.keymap.set('n', '<Leader>at', function()
    vim.cmd('tabedit')
end, {
    desc = 'New Tab',
})

----- which-key.nvim -----
PLUGINS.has_which_key, PLUGINS.which_key = pcall(require, 'which-key')
if PLUGINS.has_which_key then
    vim.opt.timeoutlen = 300
end

if PLUGINS.has_which_key then
    PLUGINS.which_key.register({
        a = {
            name = 'Action'
        },
        v = {
            name = 'Neovim',
        },
    }, { prefix = '<Leader>' })
end

----- telescope.nvim -----
PLUGINS.has_telescope, PLUGINS.telescope = pcall(require, 'telescope')
if PLUGINS.has_telescope then
    PLUGINS.telescope.setup({
        defaults = {
            layout_strategy = 'flex',
            winblend = 15,
            path_display = { 'smart' },
            dynamic_preview_title = true,
            color_devicons = CONF.use_icons,
            history = {
                mappings = {
                    i = {
                        ['<C-Down>'] = 'cycle_history_next',
                        ['<C-Up>'] = 'cycle_history_prev',
                    }
                },
                limit = 500
            },
            mappings = {
                i = {
                    ['<C-?>'] = 'which_key',
                }
            },
        }
    })
    PLUGINS.telescope.builtin = require('telescope.builtin')
    PLUGINS.telescope.utils = require('telescope.utils')
    vim.keymap.set('n', '<Leader>a.', function()
        PLUGINS.telescope.builtin.resume()
    end, {
        desc = 'Reopen Telescope',
    })
    vim.keymap.set('n', '<Leader>bs', function()
        PLUGINS.telescope.builtin.find_files({
            follow = true,
        })
    end, {
        desc = 'Find Files in CWD',
    })
    vim.keymap.set('n', '<Leader>bS', function()
        PLUGINS.telescope.builtin.find_files({
            follow = true,
            search_dirs = CONF.find_files_dirs,
        })
    end, {
        desc = 'Find Files',
    })
    vim.keymap.set('n', '<Leader>bb', function()
        PLUGINS.telescope.builtin.buffers({
            sort_mru = true,
        })
    end, {
        desc = 'Buffers',
    })
    vim.keymap.set('n', '<Leader>,q', function()
        PLUGINS.telescope.builtin.quickfix()
    end, {
        desc = 'Quickfix',
    })
    vim.keymap.set('n', '<Leader>,l', function()
        PLUGINS.telescope.builtin.loclist()
    end, {
        desc = 'Locations',
    })
    vim.keymap.set('n', '<Leader>,j', function()
        PLUGINS.telescope.builtin.jumplist()
    end, {
        desc = 'Jumps',
    })
    vim.keymap.set('n', '<Leader>,d', function()
        PLUGINS.telescope.builtin.diagnostics()
    end, {
        desc = 'Diagnostics',
    })
    vim.keymap.set('n', '<Leader>,m', function()
        PLUGINS.telescope.builtin.marks()
    end, {
        desc = 'Marks',
    })
    vim.keymap.set('n', '<Leader>bm', function()
        PLUGINS.telescope.builtin.man_pages({
            sections = { 'ALL' },
        })
    end, {
        desc = 'Manual Pages',
    })
    vim.keymap.set('n', '<Leader>vh', function()
        PLUGINS.telescope.builtin.help_tags()
    end, {
        desc = 'Help',
    })
    vim.keymap.set('n', '<Leader>vk', function()
        PLUGINS.telescope.builtin.keymaps({
            show_plug = false,
        })
    end, {
        desc = 'Keymapping'
    })
    vim.keymap.set('n', '<Leader>gC', function()
        PLUGINS.telescope.builtin.git_commits()
    end, {
        desc = 'Revisions'
    })
    vim.keymap.set('n', '<Leader>gb', function()
        PLUGINS.telescope.builtin.git_branches()
    end, {
        desc = 'Branches',
    })
    vim.keymap.set('n', '<Leader>gs', function()
        PLUGINS.telescope.builtin.git_status()
    end, {
        desc = 'Status',
    })
    vim.keymap.set('n', '<Leader>gS', function()
        PLUGINS.telescope.builtin.git_stash()
    end, {
        desc = 'Stash',
    })
    vim.keymap.set('c', '<C-r>', '<Plug>(TelescopeFuzzyCommandSearch)', { desc = 'Search Command History' })
    vim.keymap.set('n', '<Leader>bg', function()
        PLUGINS.telescope.builtin.live_grep({
            cwd = PLUGINS.telescope.utils.buffer_dir(),
        })
    end, {
        desc = 'grep',
    })

    if PLUGINS.has_which_key then
        PLUGINS.which_key.register({
            b = {
                name = 'Browse',
            },
            g = {
                name = 'Git',
            },
            [','] = {
                name = 'Locations'
            }
        }, {
            prefix = '<Leader>',
        })
    end
end

----- Cheatsheet.nvim -----
vim.keymap.set('n', '<Leader>v?', '<CMD>Cheatsheet<CR>', {
    desc = 'Cheatsheet'
})

----- Comment.nvim -----
PLUGINS.has_comment, PLUGINS.comment = pcall(require, 'Comment')
if PLUGINS.has_comment then
    PLUGINS.comment.setup({
        mappings = {
            basic = false,
            extra = false,
        }
    })
    vim.keymap.set('n', '<Leader>cc', function()
        return vim.v.count == 0 and '<Plug>(comment_toggle_current_linewise)' or '<Plug>(comment_toggle_linewise_count)'
    end, {
        expr = true,
        desc = 'Toggle Line'
    })
    vim.keymap.set('x', '<Leader>cc', '<Plug>(comment_toggle_linewise_visual)', {
        desc = 'Toggle Line'
    })
    vim.keymap.set('n', '<Leader>cb', function()
        return vim.v.count == 0 and '<Plug>(comment_toggle_current_blockwise)' or '<Plug>(comment_toggle_blockwise_count)'
    end, {
        expr = true,
        desc = 'Toggle Block'
    })
    vim.keymap.set('x', '<Leader>cb', '<Plug>(comment_toggle_blockwise_visual)', {
        desc = 'Toggle Block'
    })
    if PLUGINS.has_which_key then
        PLUGINS.which_key.register({
            c = {
                name = 'Comments'
            }
        }, { prefix = '<Leader>' })
    end
end

----- coc.nvim -----
if next(vim.api.nvim_get_runtime_file('plugin/coc.vim', false)) ~= 0 then
    vim.opt.hidden = true
    vim.opt.backup = false
    vim.opt.writebackup = false
    vim.opt.cmdheight = 2
    vim.opt.updatetime = 300
    vim.opt.shortmess:append('c')
    vim.g.coc_global_extensions = {
        'coc-clang-format-style-options',
        'coc-clangd',
        'coc-css',
        'coc-highlight',
        'coc-html',
        'coc-json',
        'coc-lists',
        'coc-lua',
        'coc-markdownlint',
        'coc-pyright',
        'coc-sh',
        'coc-snippets',
        'coc-toml',
        'coc-vimlsp',
        'coc-xml',
        'coc-yaml',
    }
    vim.g.coc_snippet_next = '<Tab>'
    vim.g.coc_snippet_prev = '<S-Tab>'
    vim.keymap.set('n', '<Leader>ld', '<CMD>CocDiagnostics<CR>', {
        desc = 'Diagnostics'
    })
    vim.keymap.set('n', '<Leader>lr', '<Plug>(coc-rename)', {
        desc = 'Rename'
    })
    vim.keymap.set('n', '<Leader>lR', '<Plug>(coc-refactor)', {
        desc = 'Refactor'
    })
    vim.keymap.set('n', '<Leader>lf', '<Plug>(coc-format)', {
        desc = 'Format'
    })
    vim.keymap.set('v', '<Leader>lf', '<Plug>(coc-format-selection)', {
        desc = 'Format'
    })
    vim.keymap.set('n', '<Leader>la', '<CMD>CocAction<CR>', {
        desc = 'Code Actions'
    })
    vim.keymap.set('n', '<Leader>ljd', '<Plug>(coc-definition)', {
        desc = 'Definition'
    })
    vim.keymap.set('n', '<Leader>ljD', '<Plug>(coc-declaration)', {
        desc = 'Declaration'
    })
    vim.keymap.set('n', '<Leader>lji', '<Plug>(coc-implementation)', {
        desc = 'Implementation'
    })
    vim.keymap.set('n', '<Leader>ljt', '<Plug>(coc-type-definition)', {
        desc = 'Definition'
    })
    vim.keymap.set('n', '<Leader>lj.', '<Plug>(coc-references-used)', {
        desc = 'References'
    })
    function _G.check_back_space()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s') ~= nil)
    end

    vim.keymap.set('i', '<C-Space>', 'coc#refresh()', {
        silent = true,
        expr = true
    })
    vim.keymap.set('i', '<TAB>',
        "pumvisible() ? '<C-n>' : v:lua.check_back_space() ? '<Tab>' : coc#refresh()", {
        noremap = true,
        silent = true,
        expr = true
    })
    vim.keymap.set('i', '<S-TAB>', 'pumvisible() ? "<C-p>" : "<C-h>"', {
        noremap = true,
        expr = true
    })
    vim.keymap.set('i', '<CR>',
        'pumvisible() ? coc#_select_confirm() : "<C-G>u<CR><C-R>=coc#on_enter()<CR>"', {
        silent = true,
        expr = true,
        noremap = true
    })
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp' },
        callback = function()
            vim.keymap.set('n', '<Leader>ljs',
                '<CMD>CocCommand clangd.switchSourceHeader vsplit<CR>', {
                buffer = true,
                desc = 'Switch Header/Source'
            })
        end
    })
    if PLUGINS.has_which_key then
        PLUGINS.which_key.register({
            l = {
                name = 'Language',
                j = {
                    name = 'Jump'
                }
            }
        }, {
            prefix = '<Leader>',
        })
    end
end

----- FTerm.nvim -----
PLUGINS.has_fterm, PLUGINS.fterm = pcall(require, 'FTerm')
if PLUGINS.has_fterm then
    PLUGINS.fterm.setup({
        blend = 30,
        dimensions = {
            height = 0.5,
            width = 0.65
        }
    })
    vim.keymap.set('n', '<Leader>.', PLUGINS.fterm.toggle, {
        desc = 'Terminal'
    })
end

----- fugitive -----
vim.api.nvim_create_autocmd('BufRead', {
    pattern = '*',
    callback = function()
        if vim.fn.exists(':Git') == 0 then
            return
        end
        if not vim.fn.FugitiveIsGitDir() == 1 then
            vim.keymap.set('n', '<Leader>gi', '<CMD>Git init<CR>', {
                desc = 'Init',
                buffer = true,
            })
            return
        end
        vim.keymap.set('n', '<Leader>ga', '<CMD>Gwrite<CR>', {
            desc = 'Stage File',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gd', '<CMD>Git! difftool<CR>', {
            desc = 'diff',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gm', '<CMD>Git mergetool<CR>', {
            desc = 'Merge Conflicts',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gl', '<CMD>Git log<CR>', {
            desc = 'log',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gc', '<CMD>Git commit<CR>', {
            desc = 'commit',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gP', '<CMD>Git pull --rebase<CR>', {
            desc = 'pull --rebase',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gp', '<CMD>Git push<CR>', {
            desc = 'push',
            buffer = true
        })
        vim.keymap.set('n', '<Leader>gM', '<CMD>Git push --mirror<CR>', {
            desc = 'push --mirror',
            buffer = true
        })
    end,
})

----- gitsigns.nvim -----
PLUGINS.has_gitsigns, PLUGINS.gitsigns = pcall(require, 'gitsigns')
if PLUGINS.has_gitsigns then
    PLUGINS.gitsigns.setup({
        current_line_blame = true,
        on_attach = function(bufnr)
            vim.keymap.set('n', '<Leader>ghn', PLUGINS.gitsigns.next_hunk, { buffer = bufnr, desc = 'Next' })
            vim.keymap.set('n', '<Leader>ghp', PLUGINS.gitsigns.prev_hunk, { buffer = bufnr, desc = 'Previous' })
            vim.keymap.set('n', '<Leader>ghh', PLUGINS.gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview' })
            vim.keymap.set({ 'n', 'v' }, '<Leader>ghs', PLUGINS.gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage' })
            vim.keymap.set('n', '<Leader>ghu', PLUGINS.gitsigns.undo_stage_hunk, { buffer = bufnr, desc = 'Unstage' })
            vim.keymap.set({ 'n', 'v' }, '<Leader>ghr', PLUGINS.gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset' })
        end,
    })
    if PLUGINS.has_which_key then
        PLUGINS.which_key.register({
            g = {
                name = 'Git',
                h = {
                    name = 'Hunk'
                }
            }
        }, { prefix = '<Leader>' })
    end
end

----- indent-blankline.nvim -----
PLUGINS.has_indent_blankline, PLUGINS.indent_blankline = pcall(require, 'indent_blankline')
if PLUGINS.has_indent_blankline then
    vim.opt.list = true
    vim.opt.listchars:append("space:⋅")
    vim.opt.listchars:append("eol:↴")
    PLUGINS.indent_blankline.setup {
        use_treesitter = true,
        show_end_of_line = true,
        space_char_blankline = ' ',
        show_current_context = true,
        show_current_context_start = true,
    }
end

----- lualine.nvim -----
PLUGINS.has_lualine, PLUGINS.lualine = pcall(require, 'lualine')
if PLUGINS.has_lualine then
    PLUGINS.lualine.setup({
        sections = {
            lualine_a = { { 'mode', fmt = function(str)
                return str:sub(1, 1)
            end } },
            lualine_b = { 'g:coc_status', 'branch', 'diff', {
                'diagnostics',
                sources = { 'coc' }
            }, 'filetype' },
            lualine_c = {
                {
                    'filename',
                    path = 1
                }
            }
        },
        tabline = {
            lualine_a = { { 'tabs', max_length = vim.o.columns, mode = 2 } },
        },
        options = {
            globalstatus = true,
            icons_enabled = CONF.use_icons,
        },
        extensions = {
            'fugitive',
            'quickfix',
        }
    })
end

----- neoclip -----
PLUGINS.has_neoclip, PLUGINS.neoclip = pcall(require, 'neoclip')
if PLUGINS.has_neoclip then
    PLUGINS.neoclip.setup({
        enable_persistent_history = true,
        continuous_sync = true,
        enable_macro_history = false,
        default_register = '+'
    })
    vim.keymap.set('n', '<Leader>bc', function()
        PLUGINS.telescope.extensions.neoclip.neoclip()
    end, {
        desc = 'Clipboard History',
    })
    if PLUGINS.has_telescope then
        PLUGINS.telescope.load_extension('neoclip')
    end
end

----- rooter -----
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.rooter_cd_cmd = 'lcd'

----- suda.vim -----
vim.g.suda_smart_edit = true

----- telescope-fzf-native.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_fzf, PLUGINS.telescope_fzf = pcall(PLUGINS.telescope.load_extension, 'fzf')
end

----- telescope-packer.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_packer, PLUGINS.telescope_packer = pcall(PLUGINS.telescope.load_extension, 'packer')
    if PLUGINS.has_telescope_packer then
        vim.keymap.set('n', '<Leader>vp', function()
            PLUGINS.telescope.extensions.packer.packer()
        end, {
            desc = 'Packages',
        })
    end
end

----- telescope-file-browser.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_file_browser, PLUGINS.telescope_file_browser = pcall(PLUGINS.telescope.load_extension, 'file_browser')
    vim.keymap.set('n', '<Leader>bf', function()
        PLUGINS.telescope.extensions.file_browser.file_browser({
            grouped = true,
            hidden = true,
        })
    end, {
        desc = 'File Browser'
    })
end

----- telescope-symbols.nvim -----

----- telescope-repo.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_repo, PLUGINS.telescope_repo = pcall(PLUGINS.telescope.load_extension, 'repo')
    vim.keymap.set('n', '<Leader>br', function()
        PLUGINS.telescope.extensions.repo.list({
            search_dirs = CONF.repo_dirs
        })
    end, {
        desc = 'Repositories'
    })
end

----- auto-session -----
PLUGINS.has_auto_session, PLUGINS.auto_session = pcall(require, 'auto-session')
if PLUGINS.has_auto_session then
    PLUGINS.auto_session.setup({
        auto_session_suppress_dirs = {
            '~',
        }
    })
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
end

----- session-lens -----
if PLUGINS.has_telescope and PLUGINS.has_auto_session then
    PLUGINS.has_session_lens, PLUGINS.session_lens = pcall(require, 'session-lens')
    if PLUGINS.has_session_lens then
        PLUGINS.session_lens.setup({
            previer = true,
        })
        PLUGINS.telescope.load_extension('session-lens')
        vim.keymap.set('n', '<Leader>s', function()
            PLUGINS.telescope.extensions['session-lens'].search_session()
        end, {
            desc = 'Sessions',
        })
    end
end

----- neon -----
vim.api.nvim_create_autocmd('ColorSchemePre', {
    pattern = 'neon',
    callback = function()
        vim.g.neon_bold = true
        vim.g.neon_italic_boolean = true
        vim.g.neon_italic_function = true
        vim.g.neon_italic_keyword = true
        vim.g.neon_italic_variable = true
    end,
})
pcall(vim.cmd, 'colorscheme neon')

----- treesitter -----
local status, treesitter_config = pcall(require, 'nvim-treesitter.configs')
if status then
    treesitter_config.setup({
        highlight = {
            enable = true
        }
    })
end

----- glow.nvim -----
PLUGINS.has_glow = vim.fn.exists(':Glow') ~= 0
if PLUGINS.has_glow then
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
            vim.keymap.set('n', '<Leader>r', '<CMD>Glow<CR>', {
                desc = 'Render Markdown',
                buffer = true,
            })
        end,
    })
end

----- 42 -----
if CONF.flavour42.is_enabled then
    vim.g.user42 = CONF.flavour42.username
    vim.g.mail42 = CONF.flavour42.email
    vim.opt.expandtab = false
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp', 'make' },
        callback = function()
            vim.keymap.set('n', '<Leader>4h', '<CMD>Stdheader<CR>', {
                desc = '42 Header',
                buffer = true,
            })
            if PLUGINS.has_which_key then
                PLUGINS.which_key.register({
                    ['4'] = {
                        name = '42'
                    },
                }, {
                    prefix = '<Leader>',
                    buffer = 0,
                })
            end
        end,
    })
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp' },
        callback = function()
            vim.keymap.set('n', '<Leader>4f', '<CMD>CFormatter42<CR>', {
                desc = '42 Format',
                buffer = true,
            })
            if vim.fn.executable('norminette') and PLUGINS.has_fterm then
                vim.keymap.set('n', '<Leader>4n', function()
                    vim.cmd('write')
                    local file = vim.fn.expand('%')
                    PLUGINS.fterm.scratch({
                        cmd = 'norminette "' .. file .. '"'
                    })
                end, {
                    desc = 'norminette',
                    buffer = true,
                })
            end
            if PLUGINS.has_which_key then
                PLUGINS.which_key.register({
                    ['4'] = {
                        name = '42'
                    },
                }, {
                    prefix = '<Leader>',
                    buffer = 0,
                })
            end
        end,
    })
end
