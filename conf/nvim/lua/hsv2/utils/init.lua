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

function M.has_plugin(plugin)
    return packer_plugins and packer_plugins[plugin]
        and packer_plugins[plugin].enabled
end

-- https://www.lua.org/pil/17.3.html
M.table_set_default = (function()
    local defaults = {}
    setmetatable(defaults, { __mode = "k" })
    local metatable = { __index = function(t) return defaults[t] end }

    return (function(t, d)
        defaults[t] = d
        setmetatable(t, metatable)
    end)
end)()

M.init_packer = (function()
    local status, packer = pcall(require, 'packer')
    return (function(config)
        if not status then
            status, packer = pcall(require, 'packer')
        end
        if not status then
            return nil
        end
       local default_config = {
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
            use_icons = false,
            post_sync_script = 'lua/post_sync.lua',
            packer_conf = {
                disable_commands = true,
                display = {
                    open_fn = require('packer.util').float,
                },
                autoremove = true,
            }
        }
        if default_config.use_icons then
            local d = default_config.packer_conf.display
            default_config.packer_conf.display.working_sym = d.working_sym or ''
            default_config.packer_conf.display.removed_sym = d.removed_sym or ''
            default_config.packer_conf.display.header_sym = d.header_sym or ''
        end
        packer.init(config.packer_conf)
        packer.reset()
        return packer
    end)
end)()

-- packer.compile should be run after
function M.enable_pkg(packer, pkg, conf)
    pkg = require('hsv2.pkg.' .. pkg)
    packer.use(pkg.packer_spec)
end

function M.table_append(dst, src)
    for k, v in ipairs(src) do
        dst[k] = v
    end
end

return M
