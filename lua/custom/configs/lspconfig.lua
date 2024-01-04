local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")


lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" }
})

lspconfig.jedi_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" }
}

lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.pylsp.setup {
    on_attach = on_attach,
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {},
                    maxLineLength = 88
                }
            }
        }
    }
}

-- Markdown LSP
lspconfig.prosemd_lsp.setup {
    on_attach = on_attach,
}

lspconfig.marksman.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

-- HTML LSP
lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.ruff_lsp.setup {
    on_attach = on_attach,
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        }
    }
}

vim.diagnostic.config({
    virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float({ border = "rounded", focus = false }, { focus = false })]]

-- C++
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" }
}

lspconfig.cmake.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cmake" }
}

lspconfig.ccls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" }
}

require("sg").setup {
    on_attach = on_attach
}

-- Javascript
lspconfig.biome.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.ember.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

-- Formatter
lspconfig.ast_grep.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.efm.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = { documentFormatting = true }
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact" }
}

lspconfig.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
