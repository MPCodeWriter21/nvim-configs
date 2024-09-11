local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Set the colors for highlights
        vim.cmd "hi LspReferenceText ctermbg=100 guibg=#444466 guifg=#00aaaa"
        vim.cmd "hi LspReferenceRead ctermbg=100 guibg=#446677 guifg=0"
        vim.cmd "hi LspReferenceWrite ctermbg=100 guibg=#333355 guifg=0"
    end,
})



-- lspconfig.pyright.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "python" }
-- })

lspconfig.jedi_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" }
}

lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- lspconfig.pylsp.setup {
--     on_attach = on_attach,
--     settings = {
--         pylsp = {
--             plugins = {
--                 pycodestyle = {
--                     ignore = {},
--                     maxLineLength = 88
--                 }
--             }
--         }
--     }
-- }

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
    cmd = {
        -- see clangd --help-hidden
        "clangd",
        "--background-index",
        -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
        -- to add more checks, create .clang-tidy file in the root directory
        -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
        "--clang-tidy",
        "--completion-style=bundled",
        "--cross-file-rename",
        "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "cxx", "h", "hpp", "hxx" },
    init_options = {
        clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
    }
}

lspconfig.cmake.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cmake" }
}

-- lspconfig.ccls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "c", "cpp" }
-- }

-- require("sg").setup {
--     on_attach = on_attach
-- }

-- Javascript
lspconfig.biome.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "biome", "lsp-proxy", "--config-path=\"" .. vim.fn.stdpath("config") .. "/lua/custom/configs/biome.json\"" }
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

-- lspconfig.efm.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     init_options = { documentFormatting = true }
-- }

lspconfig.ts_ls.setup {
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
}

lspconfig.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.ltex.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
        "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex",
        "pandoc", "quarto", "rmd", "text", "python", "c", "c++"
    },
    flags = { debounce_text_changes = 300 },
})

-- Rust
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false,
            }
        }
    }
}

-- Java lsp
lspconfig.jdtls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'jdtls' }
}

-- Yaml
lspconfig.yamlls.setup {
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.yaml"
            },
        },
    }
}
