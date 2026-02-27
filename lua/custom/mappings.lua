local M = {}

M.quickfix = {
    n = {
        ["<C-m>"] = { '<cmd> cNext <CR>', "Go to the next item in the quickfix list." },
        ["<C-p>"] = { '<cmd> cprevious <CR>', "Go to the next item in the quickfix list." },
    },
}

return M
