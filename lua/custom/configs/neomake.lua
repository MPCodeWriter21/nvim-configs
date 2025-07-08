-- {
-- \ 'args': [
--     \ '--output-format=text',
--     \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"',
--     \ '--reports=no'
-- \ ],
-- \ 'errorformat':
--     \ '%A%f:%l:%c:%t: %m,' .
--     \ '%A%f:%l: %m,' .
--     \ '%A%f:(%l): %m,' .
--     \ '%-Z%p^%.%#,' .
--     \ '%-G%.%#',
-- \ 'output_stream': 'stdout',
-- \ 'postprocess': [
-- \   function('neomake#postprocess#generic_length'),
-- \   function('neomake#makers#ft#python#PylintEntryProcess'),
-- \ ]}


-- vim.g.neomake_python_pylint_maker = {
--     args = {
--         '-d', "R0914, W1203", "W0212",
--         '--output-format=text',
--         '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"',
--         '--reports=no'
--     },
--     errorformat = '%A%f:%l:%c:%t: %m,%A%f:%l: %m,%A%f:(%l): %m,%-Z%p^%.%#,%-G%.%#',
--     postprocess = {
--     vim.fn['neomake#postprocess#generic_length'],
--     vim.fn['neomake#makers#ft#python#PylintEntryProcess'],
--    }
-- }

-- vim.g.neomake_python_enabled_makers = {'pylint'}

vim.fn["neomake#configure#automake"]('nrw', 500)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,  -- Disable inline error messages
    signs = true,          -- Enable sign decorations for errors and warnings
    underline = true,      -- Enable underline decorations for errors and warnings
    update_in_insert = false,
})

  -- Error message box
vim.api.nvim_create_autocmd("CursorHold", {
buffer = bufnr,
callback = function()
    local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
end
})

