-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

local uv = vim.loop
vim.opt.shell = uv.os_uname().version:match "Windows" and "cmd" or "bash"
vim.opt.shellcmdflag = uv.os_uname().version:match "Windows" and "/c" or "-c"
vim.cmd [[
		let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
		set shellquote= shellxquote=
  ]]

-- Set a compatible clipboard manager
vim.g.clipboard = {
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
    },
}

-- My preferences
vim.opt.colorcolumn = "88"
-- vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg='Blue', bg='Blue' })
vim.wo.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.o.conceallevel = 2

-- Custom keybinds
lvim.keys.normal_mode["<leader>w"] = false
lvim.keys.normal_mode["<leader>c"] = false
lvim.keys.normal_mode["<leader>bb"] = false
lvim.keys.normal_mode["<leader>bn"] = false
lvim.keys.normal_mode["<leader>e"] = false
lvim.keys.term_mode["<C-l>"] = false

lvim.keys.normal_mode["<C-s>"] = "<Cmd>w<CR>"
lvim.keys.insert_mode["<C-s>"] = "<Cmd>w<CR>"
lvim.keys.normal_mode["<C-n>"] = "<Cmd>NvimTreeToggle<CR>"
lvim.keys.insert_mode["<C-n>"] = "<Cmd>NvimTreeToggle<CR>"
lvim.keys.normal_mode["<C-w>"] = "<Cmd>BufferKill<CR>"
lvim.keys.normal_mode["<leader>e"] = "<Cmd>NvimTreeFocus<CR>"
lvim.keys.normal_mode["<Tab>"] = "<Cmd>BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = "<Cmd>BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<Esc>"] = "<Cmd>nohlsearch<CR>"
