-- vi: et ts=4 sw=4:
-- hsv2
local M = {}
local u = require('hsv2.utils')
local _mod = 'hsv2.pkg.core'

function M.packer_spec(pkgconfig)
    local spec = {}
    if pkgconfig.plugins then
        for _, plugin in ipairs(pkgconfig.plugins) do
            if plugin.enabled then
                u.table_append(spec, require(_mod .. '.plugin.' .. plugin).packer_spec)
            end
        end
    end
    return spec
end

return M
