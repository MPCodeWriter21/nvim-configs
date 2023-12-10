local plugins = {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "pyright",
                "mypy",
                "ruff",
                "black",
                "debugpy",
                "python-lsp-server",
                "yapf",
                "docformatter",
                "lua-language-server",
                "vscode-json-language-server",
                "glow",
                "marksman",
                "clang-formatter",
                "clangd"
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
        event = "VeryLazy",
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = function()
            return require "custom.configs.nvimtree"
        end,
    },
    -- {
    --     "jose-elias-alvarez/null-ls.nvim",
    --     event = "VeryLazy",
    --     opts = function()
    --         return require  "custom.configs.null-ls"
    --     end,
    -- },
    {
        "mfussenegger/nvim-dap",
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = {"python"},
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            local path = "/data/data/com.termux/files/usr/bin/python3"
            require("dap-python").setup(path)
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
        dap.listeners.after.event_terminated["dapui_config"] = function()
                dapui.close()
            end
        dap.listeners.after.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    {
        "python-lsp/python-lsp-server",
        ft = {"python"},
    },
    {
        "kamykn/spelunker.vim",
        lazy = false,
        config = function()
            vim.opt.updatetime = 512
            vim.g.spelunker_check_type = 2
            vim.g.spelunker_disable_uri_checking = 1
        end,
    },
    -- {
    --     "pappasam/vim-filetype-formatter",
    --     event = "VeryLazy",
    --     config = function()
    --         -- Setup black
    --         vim.g.vim_filetype_formatter_commands = {
    --             python = 'yapf --no-local-style --style ~/.config/nvim/lua/custom/configs/style.yapf | isort --ca --ac --ls --ot -l 88 -q - | docformatter -', 
    --         }
    --         -- Keybindings for Normal, Visual and Insert mods
    --         vim.keymap.set('n', '<C-A-k>', ':FiletypeFormat<CR>')
    --         vim.keymap.set('v', '<C-A-k>', ':FiletypeFormat<CR>')
    --         vim.keymap.set('i', '<C-A-k>', '<ESC> <Cmd>:FiletypeFormat<CR> i')
    --     end
    -- },
    {
        "neomake/neomake",
        ft = { "python" },
        config = function()
            require "custom.configs.neomake"
        end
    },
    {
        "kylechui/nvim-surround",
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
            vim.g.tmpl_search_paths = {'~/.vim-templates'}
            vim.g.tmpl_author_name = "Mehrad Pooryoussof"
            vim.g.tmpl_company = "CodeWriter21"
            vim.g.tmpl_author_email = "CodeWriter21@gmail.com"
            vim.g.tmpl_license = "Apache License 2.0"
        end
    },
    -- {
    --     'Exafunction/codeium.vim',
    --     event = "VeryLazy",
    --     config = function()
    --         vim.keymap.set('i', '<Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true })
    --     end
    -- },
    -- {
    --     "github/copilot.vim",
    --     event = "VeryLazy",
    --     config = function()
    --         vim.g.copilot_no_tab_map = true
    --         vim.g.copilot_assume_mapped = true
    --         -- vim.keymap.set('i', '<Tab>', function () return vim.fn['copilot#Accept']() end, { expr = true })
    --     end
    -- },
    {
        'huggingface/llm.nvim',
        event = "VeryLazy",
        config = function()
            require "custom.configs.llm"
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.keymap.set('n', '<leader>tt', ':TroubleToggle<CR>')
        end,
        event = "VeryLazy"
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy"
    },
    {
        'stevearc/aerial.nvim',
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        event = "VeryLazy"
    },
    -- {
    --     'tmhedberg/SimpylFold',
    --     opts = {},
    --     ft = { "python" },
    --     dependencies = {
    --         "Konfekt/FastFold",
    --     },
    -- },
    -- {
    --     'MPCodeWriter21/nvim-treesitter-pyfold',
    --     config = function()
    --         require('nvim-treesitter.configs').setup({
    --             pyfold = {
    --                 enable = true,
    --                 custom_foldtext = true
    --             }
    --         })
    --         vim.opt.foldmethod = "expr"
    --         vim.opt.foldexpr = "nvim_treesitter#fold_expr()"
    --         vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })
    --     end,
    --     ft = { "python" },
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd = "Glow"
    },
}
return plugins
