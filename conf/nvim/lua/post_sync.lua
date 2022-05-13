local function post_packer_sync()
    if next(vim.api.nvim_get_runtime_file('plugin/coc.vim', false)) ~= 0 then
        vim.api.nvim_exec('CocUpdate', false)
    end
end

vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    callback = post_packer_sync,
})

require('packer').sync()
