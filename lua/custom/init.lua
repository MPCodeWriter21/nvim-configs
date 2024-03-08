vim.opt.colorcolumn = "88"
vim.wo.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.scrolloff = 4

-- Define function to format and save the current file
function formatAndSave()
    local file_path = vim.fn.expand('%')

    -- Read the contents of the current file
    local file_contents = vim.fn.join(vim.fn.getline(1, '$'), "\n")

    if file_path:match('.*%.py$') then
        -- Define the commands to run
        local yapf_command = 'yapf --no-local-style --style ' .. vim.fn.stdpath('config') .. '/lua/custom/configs/style.yapf'
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
    elseif file_path:match('.*%.cpp$') then
        local clang_format_command = 'clang-format --style file'
        -- Run the clang-format command with the file contents as input and capture the output
        local formatted_text = vim.fn.system(clang_format_command, file_contents)
        -- Write the formatted text back to a tempfile
        local tempfile = vim.fn.tempname()
        vim.fn.writefile(vim.fn.split(formatted_text, "\n"), tempfile)
        -- Move the temp file to the current file's location
        if vim.fn.has('mac') then
            local permission = vim.fn.trim(vim.fn.system('stat -f "%Mp%Lp"  '.. file_path))
            vim.fn.system('chmod "'.. permission.. '"  '.. tempfile)
        else
            vim.fn.system('chmod --reference='.. vim.fn.expand('%')..''.. tempfile)
        end
        vim.fn.rename(tempfile, file_path)
    else
        print("Not a supported file type")
    end
    vim.api.nvim_command('silent edit!')
end


-- Define the keymap to trigger the formatAndSave function
vim.api.nvim_set_keymap(
  'n', -- Mode: normal
  '<C-A-k>', -- Key sequence: Ctrl+Alt+L
  '<Cmd>lua formatAndSave()<CR>', -- Command to execute
  { noremap = true, silent = true } -- Options
)

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

