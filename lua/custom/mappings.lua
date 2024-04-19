local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {
            "<cmd> DapToggleBreakpoint <CR>",
            "Add break point at the line"
        },
        ["<leader>dr"] = {
            "<cmd> DapContinue <CR>",
            "Run the debugger"
        },
        ["<leader>dt"] = {
            "<cmd> lua require('dapui').toggle() <CR>",
            "Toggle dap-ui window."
        },
    }
}

return M
