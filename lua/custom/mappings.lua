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

M.nvimtree = {
    plugin = true,
    n = {

        -- Bookmark
        ["bb"] = { '<cmd> lua require("nvim-tree.api").marks.toggle() <CR>', "Toggle Bookmark" },

    }
}

M.quickfix = {
    n = {
        -- Bookmark
        ["<C-m>"] = { '<cmd> cnext <CR>', "Go to the next item in the quickfix list." },
    }
}

return M
