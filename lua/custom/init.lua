vim.opt.colorcolumn = "88"
vim.wo.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.virtualedit = 'all'
vim.opt.scrolloff = 4
vim.o.conceallevel = 2

-- Custom bg color for markdown code blocks
vim.api.nvim_set_hl(0, "@codechunk", { bg = "#303945" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
