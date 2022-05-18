-- vi: et sw=4 ts=4:
-- hsv2
return (function(_)
    local M = {}

    function M.packer_spec(config)
        return {
            {
                'rafamadriz/neon',
                config = function()
                    M.configure(config)
                end,
            },
        }
    end

    function M.configure(config)
        if config.hsv2.fancy_font then
            for _, option in ipairs({
                'bold',
                'italic_boolean',
                'italic_function',
                'italic_keyword',
                'italic_variable',
            }) do
                vim.g['neon_' .. option] = config.plugin[option] or true
            end
        end
    end

    function M.load_condition(config)
        return config.plugin.enabled
    end

    return M
end)
