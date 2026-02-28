function Format_Table(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. Format_Table(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- local os_name = format_table(vim.loop.os_uname()):lower()
-- vim.fn.input(os_name)

local plugins = {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
            require('core.utils').load_mappings('lsp')
        end,
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       opts = {} },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { 'folke/lazydev.nvim',      opts = {} },
        },
        event = "VeryLazy",
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        config = function()
            vim.g.gitblame_date_format = '%r'
        end
    },
    {
        'MPCodeWriter21/vim-templates',
        lazy = false,
        config = function()
            vim.g.tmpl_search_paths = { '~/.vim-templates' }
            vim.g.tmpl_author_name = "Mehrad Pooryoussof"
            vim.g.tmpl_company = "CodeWriter21"
            vim.g.tmpl_author_email = "CodeWriter21@gmail.com"
            vim.g.tmpl_license = "Apache License 2.0"
        end
    },
    {
        "NvChad/nvterm",
        opts = function()
            return {
                terminals = {
                    shell = "zsh",
                    list = {},
                    type_opts = {
                        float = {
                            relative = 'editor',
                            row = 0.15,
                            col = 0.1,
                            width = 0.8,
                            height = 0.7,
                            border = "single",
                        },
                        horizontal = { location = "rightbelow", split_ratio = .3, },
                        vertical = { location = "rightbelow", split_ratio = .5 },
                    }
                },
                behavior = {
                    autoclose_on_quit = {
                        enabled = false,
                        confirm = true,
                    },
                    close_on_exit = true,
                    auto_insert = true,
                },
            }
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        event = "VeryLazy",
        build = 'make',
        config = function()
            require("telescope").load_extension("fzf")
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = false,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    }
}

return plugins
