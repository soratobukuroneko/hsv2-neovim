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
        local git = 'git -C ' .. repo
        local cmd = '!'
        for _, action in ipairs({
            'stash push',
            'checkout master',
            'pull --rebase',
            'switch dev',
            'rebase master',
            'stash pop'
        }) do
            cmd = cmd .. git .. ' ' .. action .. '&&'
        end
        vim.api.nvim_exec(cmd, false)
        if os.getenv('?') == 0 then
            vim.api.nvim_exec('echohl ErrorMsg', false)
            vim.api.nvim_exec('echo ERRRRRROR', false)
            vim.api.nvim_exec('echohl None', false)
            vim.api.nvim_exec([[
                        0tabnew $MYVIMRC
                        Git mergetool
                        ]], false)
        end
        local i, post_sync = next(vim.api.nvim_get_runtime_file(post_sync, false))
        if i ~= 0 then
            fterm.scratch({
                cmd = 'nvim -Rmc "source ' .. post_sync .. '" ' .. repo .. '/History.md',
            })
        end
    end
end

return M
