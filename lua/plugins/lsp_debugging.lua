return {
	{ -- Mason setups
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"glsl_analyzer",
					"rust_analyzer",
					"texlab",
					"lua_ls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"clang-format",
					"prettier",
				},
			})
		end,
	},
	{ -- LSP support
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier.with({
						filetypes = {
							"markdown",
							"markdown.mdx",
							"json",
							"yaml",
							"html",
							"css",
							"javascript",
							"typescript",
						},
					}),
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.formatting.stylua,
				},

				on_attach = function(client, bufnr)
					if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									bufnr = bufnr,
									async = false,
								})
							end,
						})
					end
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local mason_dap = require("mason-nvim-dap")

			mason_dap.setup({
				ensure_installed = { "cppdbg", "debugpy" },
				automatic_setup = true,
				automatic_installation = true,
			})

			-- Python adapter
			dap.adapters.python = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						else
							return "python"
						end
					end,
				},
			}

			-- C++ adapter
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
			}
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp

			-- DAP UI setup
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
				},
				layouts = {
					{
						elements = { "scopes", "breakpoints", "stacks", "watches" },
						size = 40,
						position = "left",
					},
					{
						elements = { "repl", "console" },
						size = 10,
						position = "bottom",
					},
				},
				floating = {
					max_height = 0.9,
					max_width = 0.5,
					border = "rounded",
					mappings = { close = { "q", "<Esc>" } },
				},
			})

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			require("nvim-dap-virtual-text").setup()

			-- Keymaps
			local map = vim.keymap.set
			map("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
			map("n", "<F10>", dap.step_over, { desc = "Step Over" })
			map("n", "<F11>", dap.step_into, { desc = "Step Into" })
			map("n", "<F12>", dap.step_out, { desc = "Step Out" })
			map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			map("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Set Conditional Breakpoint" })
			map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
			map("n", "<leader>dl", dap.run_last, { desc = "Run Last Debug Session" })
			map("n", "<leader>dq", function()
				dap.terminate()
				dapui.close()
			end, { desc = "Quit Debug Session" })
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
		version = "1.*",
		opts = {
			keymap = { preset = "super-tab" },
			appearance = { nerd_font_variant = "normal" },
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "copilot", "lsp", "path", "snippets", "buffer" },
				providers = {
					copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true },
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
