-- vi: et sw=4 ts=40
-- hsv-20
--
local function git_repo_root(path)
    while string.len(path) > 0 do
        if vim.fn.isdirectory(path .. '/.git') ~= 0 then
            return path
        end
        path = string.match(path, '(.*)/.*')
    end
    return false
end

local function hsv2_conf_update(post_sync)
    local fterm = require('FTerm')
    local repo = git_repo_root(os.getenv('MYVIMRC'))
    if repo and vim.fn.executable('git') then
        local cmd = 'cd ' .. repo
        cmd = cmd .. '&& git stash push'
        cmd = cmd .. '&& git checkout master'
        cmd = cmd .. '&& git pull --rebase'
        cmd = cmd .. '&& git checkout localconf'
        cmd = cmd .. '&& git rebase master'
        cmd = cmd .. '&& git stash pop'
        fterm.scratch({
            cmd = cmd,
            on_exit = function()
                if (pcall(function()
                    require(os.getenv('MYVIMRC'))
                end)) then
                    if post_sync then
                        fterm.scratch({
                            cmd = 'nvim -c "source ' .. post_sync .. '"',
                        })
                    end
                else
                    vim.api.nvim_exec([[
                        0tabnew $MYVIMRC
                        Git mergetool
                        ]])
                end
            end
        })

    end
end

return {
    git_repo_root = git_repo_root,
    hsv2_conf_update = hsv2_conf_update,
}
