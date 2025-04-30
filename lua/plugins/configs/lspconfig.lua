dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false

    utils.load_mappings("lspconfig", { buffer = bufnr })

    -- if client.server_capabilities.signatureHelpProvider then
    --     require("nvchad.signature").setup(client)
    -- end

    if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- disable semanticTokens
M.on_init = function(client, _)
    if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

M.defaults = function()
    dofile(vim.g.base46_cache .. "lsp")
    require("nvchad.lsp").diagnostic_config()

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            M.on_attach(_, args.buf)
        end,
    })

    local lua_lsp_settings = {
        Lua = {
            workspace = {
                library = {
                    vim.fn.expand "$VIMRUNTIME/lua",
                    vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/luv/library",
                },
            },
        },
    }

    -- Support 0.10 temporarily

    if vim.lsp.config then
        vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
        vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
        vim.lsp.enable "lua_ls"
    else
        require("lspconfig").lua_ls.setup {
            capabilities = M.capabilities,
            on_init = M.on_init,
            settings = lua_lsp_settings,
        }
    end
end

require("lspconfig").lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

return M
