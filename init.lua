local base_dir = vim.env.LUNARVIM_BASE_DIR
  or (function()
    local init_path = debug.getinfo(1, "S").source
    return init_path:sub(2):match("(.*[/\\])"):sub(1, -2)
  end)()

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:prepend(base_dir)
end

require("lvim.bootstrap"):init(base_dir)

require("lvim.config"):load()

local plugins = require "lvim.plugins"

require("lvim.plugin-loader").load { plugins, lvim.plugins }

require("lvim.core.theme").setup()

local Log = require "lvim.core.log"
Log:debug "Starting LunarVim"

local commands = require "lvim.core.commands"
commands.load(commands.defaults)

-- Define function to format and save the current file
function FormatAndSave()
    local file_path = vim.fn.expand('%')

    -- Read the contents of the current file
    local file_contents = vim.fn.join(vim.fn.getline(1, '$'), "\n")

    if file_path:match('.*%.py$') then
        -- Define the commands to run
        local yapf_command = 'yapf --no-local-style --style ' ..
            vim.fn.stdpath('config') .. '/lua/custom/configs/style.yapf'
        local isort_command = 'isort --ca --ac --ls --ot -l 88 -q '
        local docformatter_command = 'docformatter -i --black '

        -- Run the yapf command with the file contents as input and capture the output
        local formatted_text = vim.fn.system(yapf_command, file_contents)

        -- Write the formatted text back to a tempfile
        local tempfile = vim.fn.tempname()
        vim.fn.writefile(vim.fn.split(formatted_text, "\n"), tempfile)
        -- Run the remaining commands
        vim.fn.system(isort_command .. tempfile)
        vim.fn.system(docformatter_command .. tempfile)
        -- Move the temp file to the current file's location
        if vim.fn.has('mac') then
            local permission = vim.fn.trim(vim.fn.system('stat -f "%Mp%Lp"  ' .. file_path))
            vim.fn.system('chmod "' .. permission .. '"  ' .. tempfile)
        else
            vim.fn.system('chmod --reference=' .. vim.fn.expand('%') .. ' ' .. tempfile)
        end
        vim.fn.rename(tempfile, file_path)
    elseif file_path:match('.*%.cpp$') or file_path:match('.*%.hpp$') or
        file_path:match('.*%.inl$') or file_path:match('.*%.c$') or
        file_path:match('.*%.h$') then
        local clang_format_command = 'clang-format --style file'
        -- Run the clang-format command with the file contents as input and capture the output
        local formatted_text = vim.fn.system(clang_format_command, file_contents)
        -- Write the formatted text back to a tempfile
        local tempfile = vim.fn.tempname()
        vim.fn.writefile(vim.fn.split(formatted_text, "\n"), tempfile)
        -- Move the temp file to the current file's location
        if vim.fn.has('mac') then
            local permission = vim.fn.trim(vim.fn.system('stat -f "%Mp%Lp"  ' .. file_path))
            vim.fn.system('chmod "' .. permission .. '"  ' .. tempfile)
        else
            vim.fn.system('chmod --reference=' .. vim.fn.expand('%') .. '' .. tempfile)
        end
        vim.fn.rename(tempfile, file_path)
    elseif file_path:match('.*%.%yaml$') or file_path:match('.*%.%yml$') then
        local yamlfmt_command = 'yamlfmt -'
        local formatted_text = vim.fn.system(yamlfmt_command, file_contents)
        local tempfile = vim.fn.tempname()
        vim.fn.writefile(vim.fn.split(formatted_text, "\n"), tempfile)
        if vim.fn.has('mac') then
            local permission = vim.fn.trim(vim.fn.system('stat -f "%Mp%Lp"  ' .. file_path))
            vim.fn.system('chmod "' .. permission .. '"  ' .. tempfile)
        else
            vim.fn.system('chmod --reference=' .. vim.fn.expand('%') .. ' ' .. tempfile)
        end
        vim.fn.rename(tempfile, file_path)
    else
        print("Not a supported file type")
    end
    vim.api.nvim_command('silent edit!')
end

-- Define the keymap to trigger the formatAndSave function
vim.api.nvim_set_keymap(
    'n',                              -- Mode: normal
    '<C-A-k>',                        -- Key sequence: Ctrl+Alt+K
    '<Cmd>lua FormatAndSave()<CR>',   -- Command to execute
    { noremap = true, silent = true } -- Options
)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
