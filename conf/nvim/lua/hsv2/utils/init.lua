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

function M.hsv2_conf_update(post_sync_script)
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
        if os.getenv('?') ~= 0 then
            vim.api.nvim_exec('echohl ErrorMsg', false)
            vim.api.nvim_exec('echo ERRRRRROR', false)
            vim.api.nvim_exec('echohl None', false)
            vim.api.nvim_exec([[
                        0tabnew $MYVIMRC
                        Git mergetool
                        ]], false)
        end
        -- TODO: source all scripts found
        local _, post_sync = next(vim.api.nvim_get_runtime_file(post_sync_script, false))
        if post_sync then
            fterm.scratch({
                cmd = 'nvim -Rmc "source ' .. post_sync .. '" ' .. repo .. '/History.md',
            })
        end
    end
end

function M.has_plugin_loaded(plugin)
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

-- TODO: doesn't work with nested tables, fix that
function M.set_defaults(config, defaults)
    local set = function (k, v)
        if type(config[k]) == type(v) == 'table' then
            config[k] = M.set_defaults(config[k], v)
        elseif not config[k] then
            config[k] = v
        end
    end
    config = config or {}
    if defaults then
        M.set_defaults(defaults)
    else
        defaults = require('hsv2.default')
    end
    for k, v in ipairs(defaults) do
        set(k, v)
    end
    for k, v in pairs(defaults) do
        set(k, v)
    end
    return config
end

function M.get_packer_config(config)
    local packer_config = config.packer
    if config.hsv2.use_icons then
        packer_config.display.working_sym = packer_config.display.working_sym or ''
        packer_config.display.removed_sym = packer_config.display.removed_sym or ''
        packer_config.display.header_sym = packer_config.display.header_sym or ''
    end

    return packer_config
end

M.init_packer = (function()
    local status, packer = pcall(require, 'packer')
    return (function(config)
        if not status then
            status, packer = pcall(require, 'packer')
        end
        if not status then
            return nil
        end
        packer.reset()
        packer.init(M.get_packer_config(config))
        return packer
    end)
end)()

function M.enable_pkgs(packer, config)
    vim.pretty_print(config)
    for _, pkg_config in ipairs(config) do
        M.enable_pkg(packer, pkg_config)
    end
    packer.compile()
end

-- packer.compile should be run after
function M.enable_pkg(packer, config)
    if VERBOSE then
        vim.api.nvim_exec('echo "enable pkg \'' .. config[1] .. '\'"', false)
    end
    packer.use(require('hsv2.pkg.' .. config[1]).packer_spec(config))
end

function M.table_append(dst, src)
    for k, v in ipairs(src) do
        dst[k] = v
    end
end

return M
