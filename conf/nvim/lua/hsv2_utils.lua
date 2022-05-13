-- vi: et sw=4 ts=40
-- hsv-20
--

local M = {}

function M.git_repo_root(path)
    while string.len(path) > 0 do
        if vim.fn.isdirectory(path .. '/.git') ~= 0 then
            return path
        end
        path = string.match(path, '(.*)/.*')
    end
    return false
end

function M.hsv2_conf_update(post_sync)
    local fterm = require('FTerm')
    local repo = M.git_repo_root(os.getenv('MYVIMRC'))
    if repo and vim.fn.executable('git') ~= 0 then
        local git = '!git -C ' .. repo
        vim.api.nvim_exec(git .. ' stash push', false)
        for _, action in ipairs({
            'checkout master',
            'pull --rebase',
            'switch dev',
            'rebase master',
            'stash pop'
        }) do
            if os.getenv('?') == 0 then
                vim.api.nvim_exec('echohl ErrorMsg', false)
                vim.api.nvim_exec('echo ERRRRRROR', false)
                vim.api.nvim_exec('echohl None', false)
                break
            end
            vim.api.nvim_exec(git .. ' ' .. action, false)
        end
        vim.api.nvim_exec('!' .. cmd, false)
        vim.api.nvim_exec([[
                        0tabnew $MYVIMRC
                        Git mergetool
                        ]])
        post_sync = next(vim.api.nvim_get_runtime_file(post_sync, false))
        if post_sync ~= nil then
            fterm.scratch({
                cmd = 'nvim -c "source ' .. post_sync .. '" ' .. repo .. '/History.md',
            })
        end
    end
end

return M
