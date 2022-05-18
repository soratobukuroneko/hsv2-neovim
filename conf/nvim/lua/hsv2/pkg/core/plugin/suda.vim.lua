-- vi: et ts=4 sw=4:
-- hsv2
return (function(utils)
    local M = {}

    function M.packer_spec(config)
        local spec = {
            {
                'lambdalisue/suda.vim',
                opt = true,
                config = function()
                    M.configure(config)
                end,
            },
        }
        return spec
    end

    function M.configure(config)
        utils.set_vim_global('suda', config.plugin)
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
