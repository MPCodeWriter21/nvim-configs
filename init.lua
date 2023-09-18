require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- Define function to format and save the current file
function formatAndSave()  
  -- Read the contents of the current file
  local file_contents = vim.fn.join(vim.fn.getline(1, '$'), "\n")
  
  -- Define the commands to run
  local yapf_command = 'yapf --no-local-style --style ~/.config/nvim/lua/custom/configs/style.yapf'
  local isort_command = 'isort --ca --ac --ls --ot -l 88 -q '
  local docformatter_command = 'docformatter -i '
  
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
    local permission = vim.fn.trim(vim.fn.system('stat -f "%Mp%Lp"  ' .. vim.fn.expand('%')))
    vim.fn.system('chmod "' .. permission .. '"  ' .. tempfile)
  else
    vim.fn.system('chmod --reference=' .. expand('%') .. ' ' .. tempfile)
  end
  vim.fn.rename(tempfile, vim.fn.expand('%'))
  vim.api.nvim_command('silent edit!')
end


-- Define the keymap to trigger the formatAndSave function
vim.api.nvim_set_keymap(
  'n', -- Mode: normal
  '<C-A-k>', -- Key sequence: Ctrl+Alt+L
  '<Cmd>lua formatAndSave()<CR>', -- Command to execute
  { noremap = true, silent = true } -- Options
)
