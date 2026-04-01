return {
    "easymotion/vim-easymotion",
    { -- Autopairs for brackets and quotes.
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        "rmagatti/auto-session",
        lazy = false,
        config = function()
            local function restore_nvim_tree()
                require("nvim-tree.api").tree.open({ focus = false })
            end
            require('auto-session').setup {
                auto_restore_enabled = true,
                auto_save_enabled = true,
                suppressed_dirs = { "~/Downloads", "/", "~" },
                post_restore_cmds = { restore_nvim_tree }
            }
        end,
    },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
    },
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                shade_terminals = true,
                direction = "float", -- default (optional)
                float_opts = {
                    border = "rounded",
                },
            })
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            local nvim_tree = require("nvim-tree")
            local api = require("nvim-tree.api")
            -- Define on_attach function
            local function on_attach(bufnr)
                -- Remove default <C-t> mapping (so global FZF <C-t> works)
                vim.keymap.set("n", "<C-t>", "<Nop>", { buffer = bufnr, silent = true })

                -- Optional: map <leader>t to open in new tab
                vim.keymap.set("n", "<leader>t", api.node.open.tab, { buffer = bufnr, silent = true })

                -- Keep default useful mappings
                vim.keymap.set("n", "<CR>", api.node.open.edit, { buffer = bufnr, silent = true })
                vim.keymap.set("n", "v", api.node.open.vertical, { buffer = bufnr, silent = true })
                vim.keymap.set("n", "s", api.node.open.horizontal, { buffer = bufnr, silent = true })
                vim.keymap.set("n", "t", api.node.open.tab, { buffer = bufnr, silent = true })
                vim.keymap.set("n", "a", api.fs.create, { buffer = bufnr, silent = true })
                vim.keymap.set("n", "d", api.fs.remove, { buffer = bufnr, silent = true })
                vim.keymap.set("n", 'r', api.fs.rename, { buffer = bufnr, silent = true })
                vim.keymap.set("n", "<leader>cd", api.tree.change_root_to_node, { buffer = bufnr, silent = true })
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                view = {
                    width = 30,
                    side = "left",
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                    custom = { "^\\.git$" },
                },
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
            })
        end,
    },
    {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "BufWinEnter",
        init = function()
            vim.g.copilot_no_maps = true
        end,
        config = function()
            -- Block the normal Copilot suggestions
            vim.api.nvim_create_augroup("github_copilot", { clear = true })
            vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
                group = "github_copilot",
                callback = function(args)
                    vim.fn["copilot#On" .. args.event]()
                end,
            })
            vim.fn["copilot#OnFileType"]()
        end,
    },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                out_dir = "build",
                options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
            }
            vim.g.vimtex_doc_enabled = 0
            vim.g.vimtex_complete_enabled = 0
            vim.g.vimtex_syntax_enabled = 0
            vim.g.vimtex_imaps_enabled = 0
            vim.g.vimtex_view_forward_search_on_start = 0
            vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<return>")
            vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<return>")
        end
    },
    {
        'arminveres/md-pdf.nvim',
        branch = 'main', -- you can assume that main is somewhat stable until releases will be made
        lazy = true,
        keys = {
            {
                "<leader>,",
                function() require("md-pdf").convert_md_to_pdf() end,
                desc = "Markdown preview",
            },
        },
        ---@type md-pdf.config
        opts = {},
        config = function()
            require('md-pdf').setup()
        end,
    },
    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                -- Text objects for selecting fields
                -- textobject_field_inner = { "if", mode = { "o", "x" } },
                -- textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                -- jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                -- jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                -- jump_next_row = { "<Enter>", mode = { "n", "v" } },
                -- jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
            -- See Configuration section for options
            window = {
                layout = 'vertical',
                width = 0.2,
                border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
                title = '🤖 AI Assistant',
            },

            headers = {
                user = '👤 You',
                assistant = '🤖 Copilot',
                tool = '🔧 Tool',
            },

            separator = '━━',
            auto_fold = true, -- Automatically folds non-assistant messages
        },
    },
    {

        "yetone/avante.nvim",
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        version = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "stevearc/dressing.nvim",
            "ibhagwan/fzf-lua",
            "nvim-lua/plenary.nvim",
            "zbirenbaum/copilot.lua",
            "MunifTanjim/nui.nvim",
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = { file_types = { "markdown", "Avante" } },
                ft = { "markdown", "Avante" },
            },
        },
        opts = {
            provider = "copilot",
            providers = {
                copilot = {
                    model = "gpt-5",
                },
            },
            behaviour = {
                confirmation_ui_style = "popup",
                auto_apply_diff_after_generation = false,
                auto_approve_tool_permissions = false,
            }
        },
    }
}
