-- vi: et sw=4 ts=4:
-- hsv2
return (function(_)
    local M = {}

    function M.packer_spec(_)
        return {
            { 'gentoo/gentoo-syntax', opt = true },
        }
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
