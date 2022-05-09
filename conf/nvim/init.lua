-- vi: et sw=4 ts=4
FLAVOUR_42 = false

PLUGINS = {}

local pkgs = {
    'wbthomason/packer.nvim',
    'tami5/sqlite.lua', -- needed by some plugins
    'nvim-treesitter/nvim-treesitter', -- ditto
    'nvim-lua/plenary.nvim', -- ibidem
    'gentoo/gentoo-syntax',
    'sheerun/vim-polyglot',
    'sudormrfbin/cheatsheet.nvim',
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
    'nvim-telescope/telescope.nvim',
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
    },
    'nvim-telescope/telescope-packer.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'cljoly/telescope-repo.nvim',
    'rmagatti/auto-session',
    'rmagatti/session-lens',
    'rafamadriz/neon', -- theme
}
if FLAVOUR_42 then
    table.insert(pkgs, '42Paris/42header')
    table.insert(pkgs, 'cacharle/c_formatter_42.vim')
end

PLUGINS.has_packer, PLUGINS.packer = pcall(require, 'packer')
if not PLUGINS.has_packer then
    require('bootstrap').bootstrap_packer({pkgs})
else
    PLUGINS.packer.startup({pkgs})
end

----- Core ------
vim.g.mapleader = ' '
vim.g.localleader = ','
vim.keymap.set(
{ 'n', 'v' },
'<Space>',
'<Nop>'
)
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
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = vim.highlight.on_yank
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'make',
    callback = function()
        vim.opt_local.expandtab = false
    end
})

----- which-key.nvim -----
PLUGINS.has_which_key_nvim, PLUGINS.which_key_nvim = pcall(require, 'which-key')
if has_which_key_nvim then
    vim.opt.timeoutlen = 300
end

----- telescope.nvim -----
PLUGINS.has_telescope, PLUGINS.telescope = pcall(require, 'telescope')
if PLUGINS.has_telescope then
    PLUGINS.telescope.setup({
        defaults = {
            winblend = 30,
            path_display = { 'smart' },
            dynamic_preview_title = true,
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
            vimgrep_arguments = {
                'grep',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
            }
        }
    })
    vim.keymap.set('n', '<Leader>t<Space>', '<CMD>Telescope resume<CR>', { desc = 'Reopen' })
    vim.keymap.set('n', '<Leader>tf', '<CMD>Telescope find_files<CR>', { desc = 'Find Files' })
    vim.keymap.set('n', '<Leader>tB', '<CMD>Telescope buffers<CR>', { desc = 'Buffers' })
    vim.keymap.set('n', '<Leader>tq', '<CMD>Telescope quickfix<CR>', { desc = 'Quickfix' })
    vim.keymap.set('n', '<Leader>tm', '<CMD>Telescope man_pages section=["ALL"]<CR>', { desc = 'Manual Pages' })
    vim.keymap.set('n', '<Leader>th', '<CMD>Telescope help_tags<CR>', { desc = 'Help' })
    vim.keymap.set('n', '<Leader>tk', '<CMD>Telescope keymaps<CR>', { desc = 'Keymaps' })
    vim.keymap.set('n', '<Leader>tgc', '<CMD>Telescope git_bcommits<CR>', { desc = 'Commits' })
    vim.keymap.set('n', '<Leader>tgb', '<CMD>Telescope git_branches<CR>', { desc = 'Branches' })
    vim.keymap.set('n', '<Leader>tgs', '<CMD>Telescope git_status<CR>', { desc = 'Status' })
    vim.keymap.set('c', '<C-r>', '<Plug>(TelescopeFuzzyCommandSearch)', { desc = 'Search Command History' })

    if PLUGINS.has_which_key_nvim then
        PLUGINS.which_key_nvim.register({
            t = {
                name = 'Telescope',
                g = {
                    name = 'Git'
                }
            }
        }, { prefix = '<Leader>' })
    end
end

----- Cheatsheet.nvim -----
vim.keymap.set('n', '<Leader>?', '<CMD>Cheatsheet<CR>', {
    desc = 'Cheatsheet'
})

----- Comment.nvim -----
PLUGINS.has_comment_nvim, PLUGINS.comment_nvim = pcall(require, 'Comment')
if has_comment_nvim then
    comment_nvim.setup({
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
} )
vim.keymap.set('n', '<Leader>cb', function()
    return vim.v.count == 0 and '<Plug>(comment_toggle_current_blockwise)' or '<Plug>(comment_toggle_blockwise_count)'
end, {
expr = true,
desc = 'Toggle Block'
})
vim.keymap.set('x', '<Leader>cb', '<Plug>(comment_toggle_blockwise_visual)', {
    desc = 'Toggle Block'
})
if PLUGINS.has_which_key_nvim then
    PLUGINS.which_key_nvim.register({
        c = {
            name = 'Comments'
        }
    }, { prefix = '<Leader>' })
end
end

----- coc.nvim -----
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
vim.keymap.set('n', '<Leader>ljr', '<Plug>(coc-references-used)', {
    desc = 'References'
})
function _G.check_back_space()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s'))
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
vim.cmd('highlight link CocSemDefaultLibrary TSOtherDefaultLibrary')
vim.cmd('highlight link CocSemDefaultLibraryClass TSTypeDefaultLibrary')
vim.cmd('highlight link CocSemDefaultLibraryInterface TSTypeDefaultLibrary')
vim.cmd('highlight link CocSemDefaultLibraryEnum TSTypeDefaultLibrary')
vim.cmd('highlight link CocSemDefaultLibraryType TSTypeDefaultLibrary')
vim.cmd('highlight link CocSemDefaultLibraryNamespace TSTypeDefaultLibrary')
vim.cmd('highlight link CocSemDeclaration TSOtherDeclaration')
vim.cmd('highlight link CocSemDeclarationClass TSTypeDeclaration')
vim.cmd('highlight link CocSemDeclarationInterface TSTypeDeclaration')
vim.cmd('highlight link CocSemDeclarationEnum TSTypeDeclaration')
vim.cmd('highlight link CocSemDeclarationType TSTypeDeclaration')
vim.cmd('highlight link CocSemDeclarationNamespace TSTypeDeclaration')
if PLUGINS.has_which_key_nvim then
    PLUGINS.which_key_nvim.register({
        l = {
            name = 'Language',
            j = {
                name = 'Jump'
            }
        }
    }, { prefix = '<Leader>' })
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

----- gitsigns.nvim -----
PLUGINS.has_gitsigns, PLUGINS.gitsigns = pcall(require, 'gitsigns')
if has_gitsigns then
    PLUGINS.gitsigns.setup({
        current_line_blame = true,
        on_attach = function(bufnr)
            vim.keymap.set('n', '<Leader>ghn', gitsigns.next_hunk, { buffer = bufnr, desc = 'Next' })
            vim.keymap.set('n', '<Leader>ghp', gitsigns.prev_hunk, { buffer = bufnr, desc = 'Previous' })
            vim.keymap.set('n', '<Leader>ghh', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Preview' })
            vim.keymap.set({ 'n', 'v' }, '<Leader>ghs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Stage' })
            vim.keymap.set('n', '<Leader>ghu', gitsigns.undo_stage_hunk, { buffer = bufnr, desc = 'Unstage' })
            vim.keymap.set({ 'n', 'v' }, '<Leader>ghr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Reset' })
        end,
    })
end
if PLUGINS.has_which_key_nvim then
    PLUGINS.which_key_nvim.register({
        g = {
            name = 'Git',
            h = {
                name = 'Hunk'
            }
        }
    }, { prefix = '<Leader>' })
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
                return str:sub(1,1)
            end } },
            lualine_b = {'g:coc_status', 'branch', 'diff', {
                'diagnostics',
                sources = { 'coc' }
            }, 'filetype'},
            lualine_c = {
                {
                    'filename',
                    path = 1
                }
            }
        },
        tabline = {
            lualine_a = { { 'tabs', max_length  = vim.o.columns, mode = 2 } },
        },
        options = {
            globalstatus = true,
        },
        extensions = {
            'fugitive',
            'quickfix',
        }
    })
end

----- neoclip -----
PLUGINS.has_neoclip, PLUGINS.neoclip = pcall(require, 'neoclip')
if has_neoclip then
    PLUGINS.neoclip.setup({
        enable_persistent_history = true,
        continuous_sync = true,
        enable_macro_history = false,
        default_register = '+'
    })
    vim.keymap.set('n', '<Leader>tc', '<CMD>Telescope neoclip<CR>', { desc = 'Clipboard' })
end

----- rooter -----
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.rooter_cd_cmd = 'lcd'

----- suda.vim -----
vim.g.suda_smart_edit = true

----- telescope-fzf-native.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_fzf, PLUGINS.telescope_fzf
    = pcall(PLUGINS.telescope.load_extension, 'fzf')
end

----- telescope-packer.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_fzf, PLUGINS.telescope_fzf
    = pcall(PLUGINS.telescope.load_extension, 'packer')
end

----- telescope-file-browser.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_fzf, PLUGINS.telescope_fzf
    = pcall(PLUGINS.telescope.load_extension, 'file_browser')
    vim.keymap.set('n', '<Leader>tb', '<CMD>Telescope file_browser grouped=true hidden=true<CR>', { desc = 'File Browser' })
end

----- telescope-symbols.nvim -----

----- telescope-repo.nvim -----
if PLUGINS.has_telescope then
    PLUGINS.has_telescope_fzf, PLUGINS.telescope_fzf
    = pcall(PLUGINS.telescope.load_extension, 'repo')
    vim.keymap.set('n', '<Leader>tr', '<CMD>Telescope repo list search_dirs=["~/dev"]<CR>', { desc = 'Repositories' })
end

----- auto-session -----
PLUGINS.has_auto_session, PLUGINS.auto_session = pcall(require, 'auto-session')
if PLUGINS.has_auto_session then
    PLUGINS.auto_session.setup({
        auto_session_suppress_dirs = { '~' }
    })
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
end

----- session-lens -----
if PLUGINS.has_telescope and PLUGINS.has_auto_session then
    vim.keymap.set('n', '<Leader>ts', '<CMD>Telescope session-lens search_session<CR>', { desc = 'Sessions' })
end

----- neon -----
vim.g.neon_bold = true
vim.g.neon_italic_boolean = true
vim.g.neon_italic_function = true
vim.g.neon_italic_keyword = true
vim.g.neon_italic_variable = true
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

----- 42 -----
if FLAVOUR_42 then
    vim.opt.expandtab = false
    vim.keymap.set('n', '<Leader>ah', '<CMD>Stdheader<CR>', { desc = '42 Header' })
    vim.keymap.set('n', '<Leader>af', '<CMD>CFormatter42<CR>', { desc = '42 Format' })
    if PLUGINS.has_which_key_nvim then
        PLUGINS.which_key_nvim.register({
            a = {
                name = 'Actions'
            },
        }, { prefix = '<Leader>' })
    end
end
