local function post_packer_sync()
    if vim.fn.exists(':CocCommand') ~= 0 then
        vim.api.nvim_exec('CocUpdate', false)
    end
end

vim.api.nvim_create_autocmd('User', {
    pattern = 'PackerComplete',
    callback = post_packer_sync,
})

require('packer').sync()
