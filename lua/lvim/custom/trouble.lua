local M = {}

M.config = function()
    lvim.builtin.trouble = {
        active = true,
        on_config_done = nil,
        options = {
            icons = {
                indent        = {
                    top         = "│ ",
                    middle      = "├╴",
                    last        = "╰╴",
                    fold_open   = " ",
                    fold_closed = " ",
                    ws          = "  ",
                },
                folder_closed = " ",
                folder_open   = " ",
                kinds         = {
                    Array         = " ",
                    Boolean       = "󰨙 ",
                    Class         = " ",
                    Constant      = "󰏿 ",
                    Constructor   = " ",
                    Enum          = " ",
                    EnumMember    = " ",
                    Event         = " ",
                    Field         = " ",
                    File          = " ",
                    Function      = "󰊕 ",
                    Interface     = " ",
                    Key           = " ",
                    Method        = "󰊕 ",
                    Module        = " ",
                    Namespace     = "󰦮 ",
                    Null          = " ",
                    Number        = "󰎠 ",
                    Object        = " ",
                    Operator      = " ",
                    Package       = " ",
                    Property      = " ",
                    String        = " ",
                    Struct        = "󰆼 ",
                    TypeParameter = " ",
                    Variable      = "󰀫 ",
                },
            },
            -- defaults = {
            --     mappings = {
            --         i = { ["<c-t>"] = open_with_trouble },
            --         n = { ["<c-t>"] = open_with_trouble },
            --     },
            -- },
        },
    }
end

M.setup = function()
    local status_ok, trouble = pcall(require, "trouble")
    if not status_ok then
        return
    end

    trouble.setup(lvim.builtin.trouble.options)

    if lvim.builtin.indentlines.on_config_done then
        lvim.builtin.indentlines.on_config_done()
    end
end

return M
