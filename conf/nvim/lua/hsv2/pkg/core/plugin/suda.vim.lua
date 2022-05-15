-- vi: et ts=4 sw=4:
-- hsv2
local M = {}

function M.packer_spec(config)
    local spec = {
        {
            'lambdalisue/suda.vim',
            opt = true,
            config = function()
                vim.g.suda_smart_edit = true
            end,
        },
    }
    return spec
end

return M
