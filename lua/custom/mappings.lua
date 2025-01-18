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

M.quickfix = {
    n = {
        ["<C-m>"] = { '<cmd> cNext <CR>', "Go to the next item in the quickfix list." },
        ["<C-p>"] = { '<cmd> cprevious <CR>', "Go to the next item in the quickfix list." },
    },
}

M.lsp = {
    plugin = true,
    n = {
        ["<leader>gdv"] = {
            "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>",
            "Go to definition (vertical split)"
        },
        ["<leader>gdh"] = {
            "<cmd>split | lua vim.lsp.buf.definition()<CR>",
            "Go to definition (horizontal split)"
        },
        ["<leader>qo"] = {
            "<cmd> only<CR>",
            "Close all splits except current"
        },
    }
}

return M
