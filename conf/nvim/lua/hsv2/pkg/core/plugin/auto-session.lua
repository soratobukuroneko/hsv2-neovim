-- vi: et ts=4 sw=4:
-- hsv2
local M = {}

function M.packer_spec(config)
    return {
        {
            'rmagatti/auto-session',
            opt = true,
            config = function(name, _)
                require(name).setup(config.plugin[name])
                for i, opt in ipair({
                    'blank',
                    'buffers',
                    'curdir',
                    'folds',
                    'help',
                    'tabpages',
                    'winsize',
                    'winpos',
                    'terminal',
                }) do
                vim.opt.sessionoptions:append(opt)
            end
            end,
        },
    }
end

return M
