local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local util = require 'lspconfig.util'


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
            local cursor_hold_autocmd = vim.api.nvim_create_autocmd(
                { 'CursorHold', 'CursorHoldI' },
                {
                    buffer = event.buf,
                    callback = vim.lsp.buf.document_highlight,
                }
            )

            local cursor_move_autocmd = vim.api.nvim_create_autocmd(
                { 'CursorMoved', 'CursorMovedI' },
                {
                    buffer = event.buf,
                    callback = vim.lsp.buf.clear_references,
                }
            )

            -- On filetype change, delete CursorHold and CursorMoved autocmds
            -- Thanks to Github Copilot I am forced to do this -_-
            vim.api.nvim_create_autocmd(
                'FileType',
                {
                    buffer = event.buf,
                    callback = function(filetype_event)
                        if filetype_event.buf ~= event.buf then
                            return
                        end
                        vim.api.nvim_del_autocmd(cursor_hold_autocmd)
                        vim.api.nvim_del_autocmd(cursor_move_autocmd)
                    end
                }
            )
        end

        -- Set the colors for highlights
        vim.cmd "hi LspReferenceText ctermbg=100 guibg=#444466 guifg=#00aaaa"
        vim.cmd "hi LspReferenceRead ctermbg=100 guibg=#446677 guifg=0"
        vim.cmd "hi LspReferenceWrite ctermbg=100 guibg=#333355 guifg=0"
    end,
})


-- Python LSP

-- vim.lsp.config("pyright", {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "python" }
-- })
-- vim.lsp.enable("pyright")

vim.lsp.config("jedi_language_server", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
})
vim.lsp.enable("jedi_language_server")

-- vim.lsp.config("pylsp", {
--     on_attach = on_attach,
--     capabilities = capabilities,
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
-- })
-- vim.lsp.enable("pylsp")

vim.lsp.config("ruff", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
    init_options = {
        settings = {
            pyright = {
                disableOrganizeImports = true,
            },
        }
    },
})
vim.lsp.enable("ruff")

vim.lsp.config('ty', {
    on_attach = function(client, bufnr)
        -- Disable formatting and go to definition capabilities for ty LSP
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.declarationProvider = false
        client.server_capabilities.typeDefinitionProvider = false

        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    filetypes = { "python" },
})
vim.lsp.enable('ty')

-- Json LSP

vim.lsp.config("jsonls", {
    on_attach = on_attach,
    capabilities = capabilities,
})
vim.lsp.enable("jsonls")

-- Markdown LSP
vim.lsp.config("prosemd_lsp", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("prosemd_lsp")

vim.lsp.config("marksman", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("marksman")

-- HTML LSP
vim.lsp.config("html", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("html")

vim.diagnostic.config({
    virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float({ border = "rounded", focus = false }, { focus = false })]]

-- C++
vim.lsp.config("clangd", {
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
})
vim.lsp.enable("clangd")

vim.lsp.config("cmake", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cmake" }
})
vim.lsp.enable("cmake")

-- vim.lsp.config("ccls", {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "c", "cpp" }
-- })
-- vim.lsp.enable("ccls")

-- require("sg").setup {
--     on_attach = on_attach
-- }

-- Javascript
vim.lsp.config("biome", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
        'javascript',
        'javascriptreact',
        'json',
        'jsonc',
        'typescript',
        'typescript.tsx',
        'typescriptreact',
        'astro',
        'svelte',
        'vue',
        'css',
    },
    root_dir = util.root_pattern('biome.json', 'biome.jsonc'),
    single_file_support = false,
    cmd = { "biome", "lsp-proxy" }
})
vim.lsp.enable("biome")

vim.lsp.config("ember", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("ember")

-- Formatter
vim.lsp.config("ast_grep", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("ast_grep")

-- vim.lsp.config("efm", {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     init_options = { documentFormatting = true }
-- })
-- vim.lsp.enable("efm")

vim.lsp.config("ts_ls", {
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
})
vim.lsp.enable("ts_ls")

vim.lsp.config("bashls", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("bashls")

vim.lsp.config("ltex", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
        "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex",
        "pandoc", "quarto", "rmd", "text", "python", "c", "c++"
    },
    flags = { debounce_text_changes = 300 },
})
vim.lsp.enable("ltex")

-- Java lsp
vim.lsp.config("jdtls", {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'jdtls' }
})
vim.lsp.enable("jdtls")

-- Yaml
vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.yaml"
            },
        },
    }
})
vim.lsp.enable("yamlls")

-- Rust Analyzer
vim.lsp.config("rust_analyzer", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})
vim.lsp.enable("rust_analyzer")

-- Zig LSP
vim.lsp.config("zls", {
    on_attach = on_attach,
    capabilities = capabilities
})
vim.lsp.enable("zls")

-- Golang LSP
vim.lsp.config("gopls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                useany = true,
            },
            staticcheck = true,
            codelenses = {
                gc_details = true,
                generate = true,
                test = true,
                tidy = true,
            },
        }
    }
})
vim.lsp.enable("gopls")
