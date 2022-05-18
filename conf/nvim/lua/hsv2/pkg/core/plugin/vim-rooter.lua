-- vi: et ts=4 sw=4:
-- hsv2
return (function(utils)
    local M = {
        handlers = {},
    }

    function M.packer_spec(config)
        function M.handlers.config()
            utils.set_vim_global('rooter_', config.plugin.vim_globals)
        end

        function M.handlers.cond()
            return config.plugin.enabled
        end

        return {
            utils.make_packer_spec('airblade/vim-rooter', M.handlers)
        }
    end

    return M
end)
