-- vi: et ts=4 sw=4:
-- hsv2
return (function(utils)
    local M = {}
    local _pkg_prefix = 'hsv2.pkg.'

    function M.packer_spec(config)
        local spec = {}
        for pkg, pkgconfig in pairs(config.packages) do
            if pkgconfig.plugins then
                for plugin, pluginconfig in pairs(pkgconfig.plugins) do
                    utils.table_append(spec,
                        require(_pkg_prefix .. pkg .. '.plugin.' .. plugin)(utils)
                        .packer_spec({ hsv2 = config.hsv2, plugin = pluginconfig }))
                end
            end
        end
        return spec
    end

    return M
end)
