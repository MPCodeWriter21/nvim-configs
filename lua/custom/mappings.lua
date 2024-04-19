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

M.compiler = {
    plugin = true,
    n = {
        ["<C-b>"] = {
            "<cmd> CompilerOpen <CR>",
            "Open compiler"
        },
        ["<leader>j"] = {
            "<cmd> CompilerStop <CR> <cmd> CompilerRedo <CR>",
            "Redo the last compiler command"
        },
        ["<leader>k"] = {
            "<cmd> CompilerToggleResults <CR>",
            "Toggle compiler results"
        },
    }
}

return M
