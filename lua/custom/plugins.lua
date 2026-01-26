local function convert_path(path)
    local drive_letter, rest_of_path = path:match("^([A-Za-z]):(.*)")

    if drive_letter then
        -- Convert Windows-style path to Unix-style path
        local unix_path = "/" .. drive_letter:lower() .. rest_of_path:gsub("\\", "/")
        return unix_path
    else
        -- Path is already in Unix-style, return as is
        return path
    end
end
local function adjust_path_separator(path)
    if package.config:sub(1, 1) == "\\" then
        -- Windows platform, replace forward slashes with backslashes
        return path:gsub("/", "\\")
    else
        -- Non-Windows platform, return as is
        return path
    end
end
local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function format_table(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. format_table(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local os_name = format_table(vim.loop.os_uname()):lower()
-- vim.fn.input(os_name)

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
                "glow",
                "marksman",
                "clangd",
                "ember-language-server",
                "biome",
                "ast-grep",
                "jedi-language-server",
                "bash-language-server",
                "ltex-ls",
                "rust-analyzer",
                "jdtls",
                "yaml-language-server",
                "prosemd-lsp",
                "codelldb",
                "typescript-language-server",
                "yamlfmt",
                "gopls"
            },
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependncies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap"
        },
        opts = {
            handlers = {},
        },
    },
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
    -- {
    --     "nvim-tree/nvim-tree.lua",
    --     opts = function()
    --         return require "custom.configs.nvimtree"
    --     end,
    -- },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        opts = function()
            return require "custom.configs.none-ls"
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio"
        },
        config = function(_, _)
            require('core.utils').load_mappings('dap')
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
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
        event = "VeryLazy",
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
    -- {
    --     "python-lsp/python-lsp-server",
    --     ft = { "python" },
    -- },
    {
        "kamykn/spelunker.vim",
        lazy = false,
        config = function()
            if os_name:find("android") ~= nil then
                return
            end
            -- Make sure spell directory exists
            vim.fn.mkdir(vim.fn.stdpath('config') .. '/spell', 'p')
            -- print(vim.fn.stdpath('config') .. adjust_path_separator('/spell/custom-en.utf-8.add'))
            -- Wait for user to press enter
            -- vim.fn.input("Press enter to continue...")
            -- vim.cmd(':set spellfile="' ..
            --     vim.fn.stdpath('config') .. adjust_path_separator('/spell/custom-en.utf-8.add') .. '"')

            local config_path = vim.fn.stdpath('config')
            -- Check if we got multiple config paths (For the sake of lsp)
            if (type(config_path) == "string") then
                -- Set the spell file
                local spellfile = adjust_path_separator(
                    vim.fs.joinpath(config_path, 'spell', 'custom.en.utf-8.add')
                )
                -- vim.fn.input(spellfile)
                -- vim.o.spellfile = spellfile
            end

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
    -- {
    --     "neomake/neomake",
    --     ft = { "python" },
    --     config = function()
    --         require "custom.configs.neomake"
    --     end
    -- },
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
            vim.g.tmpl_search_paths = { '~/.vim-templates' }
            vim.g.tmpl_author_name = "Mehrad Pooryoussof"
            vim.g.tmpl_company = "CodeWriter21"
            vim.g.tmpl_author_email = "CodeWriter21@gmail.com"
            vim.g.tmpl_license = "Apache License 2.0"
        end
    },
    {
        "github/copilot.vim",
        event = "VeryLazy",
        config = function()
            -- vim.g.copilot_no_tab_map = true
            -- vim.g.copilot_assume_mapped = true
            -- vim.keymap.set('i', '<Tab>', function () return vim.fn['copilot#Accept']() end, { expr = true })
        end
    },
    -- {
    --     'MPCodeWriter21/llm.nvim',
    --     -- commit = "7bf97d0",
    --     event = "VeryLazy",
    --     config = function()
    --         require "custom.configs.llm"
    --     end
    -- },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
        cmd = "Trouble",
        opts = {
            icons = {
                ---@type trouble.Indent.symbols
                indent        = {
                    top         = "│ ",
                    middle      = "├╴",
                    last        = "╰╴",
                    fold_open   = " ",
                    fold_closed = " ",
                    ws          = "  ",
                },
                folder_closed = " ",
                folder_open   = " ",
                kinds         = {
                    Array         = " ",
                    Boolean       = "󰨙 ",
                    Class         = " ",
                    Constant      = "󰏿 ",
                    Constructor   = " ",
                    Enum          = " ",
                    EnumMember    = " ",
                    Event         = " ",
                    Field         = " ",
                    File          = " ",
                    Function      = "󰊕 ",
                    Interface     = " ",
                    Key           = " ",
                    Method        = "󰊕 ",
                    Module        = " ",
                    Namespace     = "󰦮 ",
                    Null          = " ",
                    Number        = "󰎠 ",
                    Object        = " ",
                    Operator      = " ",
                    Package       = " ",
                    Property      = " ",
                    String        = " ",
                    Struct        = "󰆼 ",
                    TypeParameter = " ",
                    Variable      = "󰀫 ",
                },
            },
        },
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
            ["]]"] = "next",
        },
        event = "VeryLazy"
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            require('todo-comments').setup()
        end
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
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd = "Glow"
    },
    -- {
    --     "TabbyML/vim-tabby",
    --     event = "VeryLazy"
    -- },
    -- {
    --     "sourcegraph/sg.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim" ]] },
    --     event = "VeryLazy"
    -- },
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
                            row = 0.3,
                            col = 0.25,
                            width = 0.5,
                            height = 0.4,
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
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
        config = function()
            local config = {
                cmd = { 'jdtls' },
                root_dir = vim.fs.dirname(vim.fs.find(
                    { 'gradlew', '.git', 'mvnw' }, { upward = true })[1]
                ),
            }

            local sep = ';'
            if os_name:find("windows") == nil then
                sep = ':'
            end
            config.settings = {
                java = {
                    project = {
                        -- Load the $CLASSPATH and split it by :
                        referencedLibraries = split(os.getenv('CLASSPATH'), sep),
                        -- referencedLibraries = {
                        --     "/data/data/com.termux/files/home/java/jar/org.json-1.6-20240205.jar"
                        -- },
                    }
                }
            }
            -- vim.fn.input(format_table(config))
            require('jdtls').start_or_attach(config)
        end
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
        dependncies = {
            "nvim-lua/plenary.nvim",
            "epwalsh/pomo.nvim"
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/vaults/personal",
                },
                {
                    name = "work",
                    path = "~/vaults/work",
                },
            },
            ui = {
                enable = true,         -- set to false to disable all additional syntax features
                update_debounce = 200, -- update delay after a text change (in milliseconds)
                -- Define how various check-boxes are displayed
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                },
                -- Use bullet marks for non-checkbox lists.
                bullets = { char = "•", hl_group = "ObsidianBullet" },
                external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                reference_text = { hl_group = "ObsidianRefText" },
                highlight_text = { hl_group = "ObsidianHighlightText" },
                tags = { hl_group = "ObsidianTag" },
                block_ids = { hl_group = "ObsidianBlockID" },
                hl_groups = {
                    -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                    ObsidianTodo = { bold = true, fg = "#f78c6c" },
                    ObsidianDone = { bold = true, fg = "#89ddff" },
                    ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                    ObsidianTilde = { bold = true, fg = "#ff5370" },
                    ObsidianBullet = { bold = true, fg = "#89ddff" },
                    ObsidianRefText = { underline = true, fg = "#c792ea" },
                    ObsidianExtLinkIcon = { fg = "#c792ea" },
                    ObsidianTag = { italic = true, fg = "#89ddff" },
                    ObsidianBlockID = { italic = true, fg = "#89ddff" },
                    ObsidianHighlightText = { bg = "#75662e" },
                },
            },
        },
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
        "Zeioth/compiler.nvim",
        event = "VeryLazy",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim" },
        opts = {},
        config = function(opts)
            require('core.utils').load_mappings('compiler')
            require('compiler').setup(opts)
        end
    },
    {
        "stevearc/overseer.nvim",
        tag = "v1.6.0",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1
            },
        },
    },
    -- {
    --     "ray-x/lsp_signature.nvim",
    --     event = "VeryLazy",
    --     opts = {},
    --     config = function(_, opts) require 'lsp_signature'.setup(opts) end
    -- },
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         cmdline = {
    --             view = "cmdline",
    --         },
    --         commands = {
    --             history = {
    --                 -- options for the message history that you get with `:Noice`
    --                 view = "split",
    --                 opts = { enter = true, format = "details" },
    --                 filter = {
    --                     any = {
    --                         { event = "notify" },
    --                         { error = true },
    --                         { warning = true },
    --                         { event = "msg_show", kind = { "" } },
    --                         { event = "lsp",      kind = "message" },
    --                     },
    --                 },
    --             },
    --             -- :Noice last
    --             last = {
    --                 view = "popup",
    --                 opts = { enter = true, format = "details" },
    --                 filter = {
    --                     any = {
    --                         { event = "notify" },
    --                         { error = true },
    --                         { warning = true },
    --                         { event = "msg_show", kind = { "" } },
    --                         { event = "lsp",      kind = "message" },
    --                     },
    --                 },
    --                 filter_opts = { count = 1 },
    --             },
    --             -- :Noice errors
    --             errors = {
    --                 -- options for the message history that you get with `:Noice`
    --                 view = "popup",
    --                 opts = { enter = true, format = "details" },
    --                 filter = { error = true },
    --                 filter_opts = { reverse = true },
    --             },
    --             all = {
    --                 -- options for the message history that you get with `:Noice`
    --                 view = "split",
    --                 opts = { enter = true, format = "details" },
    --                 filter = {},
    --             },
    --         },
    --         lsp = {
    --             progress = {
    --                 enabled = true,
    --                 -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
    --                 -- See the section on formatting for more details on how to customize.
    --                 --- @type NoiceFormat|string
    --                 format = "lsp_progress",
    --                 --- @type NoiceFormat|string
    --                 format_done = "lsp_progress_done",
    --                 throttle = 1000 / 30, -- frequency to update lsp progress message
    --                 view = "mini",
    --             },
    --             override = {
    --                 -- override the default lsp markdown formatter with Noice
    --                 ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
    --                 -- override the lsp markdown formatter with Noice
    --                 ["vim.lsp.util.stylize_markdown"] = false,
    --                 -- override cmp documentation with Noice (needs the other options to work)
    --                 ["cmp.entry.get_documentation"] = false,
    --             },
    --             hover = {
    --                 enabled = true,
    --                 silent = false, -- set to true to not show a message if hover is not available
    --                 view = nil,     -- when nil, use defaults from documentation
    --                 ---@type NoiceViewOptions
    --                 opts = {},      -- merged with defaults from documentation
    --             },
    --             signature = {
    --                 enabled = true,
    --                 auto_open = {
    --                     enabled = true,
    --                     trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
    --                     luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
    --                     throttle = 50,  -- Debounce lsp signature help request by 50ms
    --                 },
    --                 view = nil,         -- when nil, use defaults from documentation
    --                 ---@type NoiceViewOptions
    --                 opts = {},          -- merged with defaults from documentation
    --             },
    --             message = {
    --                 -- Messages shown by lsp servers
    --                 enabled = true,
    --                 view = "notify",
    --                 opts = {},
    --             },
    --             -- defaults for hover and signature help
    --             documentation = {
    --                 view = "hover",
    --                 ---@type NoiceViewOptions
    --                 opts = {
    --                     lang = "markdown",
    --                     replace = true,
    --                     render = "plain",
    --                     format = { "{message}" },
    --                     win_options = { concealcursor = "n", conceallevel = 3 },
    --                 },
    --             },
    --         },
    --         smart_move = {
    --             -- noice tries to move out of the way of existing floating windows.
    --             enabled = true, -- you can disable this behaviour here
    --             -- add any filetypes here, that shouldn't trigger smart move.
    --             excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
    --         },
    --         -- you can enable a preset for easier configuration
    --         presets = {
    --             bottom_search = true,         -- use a classic bottom cmdline for search
    --             command_palette = false,      -- position the cmdline and popupmenu together
    --             long_message_to_split = true, -- long messages will be sent to a split
    --             inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    --             lsp_doc_border = true,        -- add a border to hover docs and signature help
    --         },
    --     },
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "rcarriga/nvim-notify",
    --     }
    -- },
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
        "tpope/vim-surround",
        event = "VeryLazy"
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


-- Check if the operating system is not android
if os_name:find("android") == nil then
    -- Add Codeium to the plugins
    -- table.insert(plugins,
    --     {
    --         {
    --             "Exafunction/codeium.nvim",
    --             event = "VeryLazy",
    --             dependencies = {
    --                 "nvim-lua/plenary.nvim",
    --                 "hrsh7th/nvim-cmp",
    --             },
    --             config = function()
    --                 require("codeium").setup({})
    --             end
    --         },
    --     }
    -- )
end


return plugins
