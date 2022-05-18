-- vi: et sw=4 ts=4:
-- hsv2
local M = {}

M.hsv2 = {
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
    packages = {
        { 'core' },
    }
}

M.packer = {
    --disable_commands = true,
    display = {
        open_fn = require('packer.util').float,
    },
    autoremove = true,
}

return M
