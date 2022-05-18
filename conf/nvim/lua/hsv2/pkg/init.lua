-- vi: et ts=4 sw=4:
-- hsv2
local M = {}
local u = require('hsv2.utils')
local _pkg_prefix = 'hsv2.pkg.'

function M.packer_spec(config)
    local spec = {}
    for _, pkg in ipairs(config) do
        if pkg.enabled then
            u.table_append(spec, require(_pkg_prefix .. pkg).packer_spec)
        end
    end
    return spec
end

return M
