vim.opt.colorcolumn = "88"
vim.wo.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.scrolloff = 4

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#fold_expr()"
-- vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })

-- vim.opt.foldmethod = "indent"
-- vim.opt.foldnestmax = 2

-- function format_code()
--    output = vim.fn.system(
--        'yapf --no-local-style --style %localappdata%/nvim/lua/custom/configs/style.yapf | isort --ca --ac --ls --ot -l 88 -q - | docformatter -',
--         vim.fn['join'](vim.fn['getline'](1, '$'), "\n")
--     )
--     echo output
-- end

-- vim.keymap.set('n', '<C-A-l>', 'format_code')
-- vim.keymap.set('i', '<C-A-l>', 'format_code')
-- vim.keymap.set('n', '<C-A-l>', 'format_code')

