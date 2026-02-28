local M = {}

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
