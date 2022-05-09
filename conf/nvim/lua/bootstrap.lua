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

local function bootstrap_packer(pkgs)
    clone_packer()
    -- Load Packer
    vim.cmd('packadd packer.nvim')
    PLUGINS.packer = require('packer')
    -- Exit nvim after installing plugins
    --[[ vim.api.nvim_create_autocmd('PaqDoneInstall', {
            command = 'quitall'
        }) --]]
    -- Read and install packages
    PLUGINS.packer.startup(pkgs)
    PLUGINS.packer.sync()
end

return { bootstrap_packer = bootstrap_packer }
