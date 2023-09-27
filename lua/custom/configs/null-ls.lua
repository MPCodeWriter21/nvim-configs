local null_ls = require('null-ls')

local opts = {
    sources = {
        -- null_ls.builtins.diagnostics.mypy,
        -- null_ls.builtins.diagnostics.ruff,
        -- null_ls.builtins.formatting.black,
        -- null_ls.completion.spell,
        null_ls.builtins.diagnostics.curlylint,
        null_ls.builtins.diagnostics.djlint,
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.diagnostics.tidy,
        null_ls.builtins.formatting.htmlbeautifier
    },
}
return opts
