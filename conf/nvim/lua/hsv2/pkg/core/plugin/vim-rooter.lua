-- vi: et ts=4 sw=4:
-- hsv2
local M = {}

function M.packer_spec(config)
    return {
        {
            'airblade/vim-rooter',
            opt = true,
            config = function()
                vim.g.rooter_change_directory_for_non_project_files = 'current'
                vim.g.rooter_cd_cmd = 'lcd'
            end,
        },
    }
end

return M
