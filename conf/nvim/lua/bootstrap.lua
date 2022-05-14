-- vim: et sw=4 ts=4:
local function clone_packer()
    local path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system {
            'git',
            'clone',
            '--depth=1',
            'https://github.com/wbthomason/packer.nvim',
            path
        }
    end
end

local function bootstrap_packer(get_opts)
    clone_packer()
    -- Load Packer
    vim.cmd('packadd packer.nvim')
    PLUGINS.packer = require('packer')
    PLUGINS.packer.startup(get_opts())
    vim.api.nvim_create_autocmd('User', {
            pattern = 'PackerComplete',
            command = 'quitall',
        })
    PLUGINS.packer.sync()
end

return { bootstrap_packer = bootstrap_packer }
