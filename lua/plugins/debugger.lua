return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- ──────────────────────────────────────────────────────────────────
			-- ADAPTERS
			-- Add a new adapter block here for each language you want to debug
			-- ──────────────────────────────────────────────────────────────────

			-- .NET (requires: yay -S netcoredbg)
			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			-- JavaScript / TypeScript (requires: yay -S js-debug-adapter)
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				},
			}
			-- Alias so both js and ts use the same adapter
			dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

			-- ──────────────────────────────────────────────────────────────────
			-- CONFIGURATIONS
			-- Add a new configurations block here for each language
			-- ──────────────────────────────────────────────────────────────────

			-- .NET
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch project",
					request = "launch",
					program = function()
						local cwd = vim.fn.getcwd()
						-- tries to find the dll automatically, falls back to manual input
						local dll = cwd .. "/bin/Debug/net10.0/" .. vim.fn.fnamemodify(cwd, ":t") .. ".dll"
						if vim.fn.filereadable(dll) == 0 then
							dll = vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
						end
						return dll
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
					env = {
						ASPNETCORE_ENVIRONMENT = "Development",
					},
				},
				{
					type = "coreclr",
					name = "Attach to process",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}

			-- JavaScript
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file (Node)",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to Node process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome",
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
				},
			}

			-- TypeScript (reuses JS config — js-debug-adapter handles transpilation)
			dap.configurations.typescript = dap.configurations.javascript

			-- TypeScript React / JavaScript React
			dap.configurations.typescriptreact = dap.configurations.javascript
			dap.configurations.javascriptreact = dap.configurations.javascript

			-- ──────────────────────────────────────────────────────────────────
			-- UI
			-- ──────────────────────────────────────────────────────────────────
			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.6 },
							{ id = "breakpoints", size = 0.2 },
							{ id = "stacks", size = 0.2 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "console", size = 0.6 },
							{ id = "watches", size = 0.4 },
						},
						size = 12,
						position = "bottom",
					},
				},
			})

			-- Shows variable values inline next to code
			require("nvim-dap-virtual-text").setup({
				commented = true,
			})

			-- Auto open/close UI with session
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- ──────────────────────────────────────────────────────────────────
			-- KEYMAPS
			-- ──────────────────────────────────────────────────────────────────
			local map = vim.keymap.set

			map("n", "<F5>", dap.continue, { desc = "Debug: Start / Continue" })
			map("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			map("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			map("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			map("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })
			map("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
			map("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
			map("n", "<leader>dx", dap.terminate, { desc = "Debug: Terminate" })
		end,
	},
}
