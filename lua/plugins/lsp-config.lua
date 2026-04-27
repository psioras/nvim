return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			ensure_installed = {
				-- Removed omnisharp
				"lua_ls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Enable other servers
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("solargraph")
			vim.lsp.enable("html")
			vim.lsp.enable("lua_ls")
			-- Removed vim.lsp.enable("omnisharp")

			-- Keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
	-- Roslyn.nvim with auto-detection from Mason
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		dependencies = {
			"mason.nvim", -- Ensure Mason is loaded first
		},
		opts = {
			-- Removed explicit exe - let it auto-detect from Mason
			args = {
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			},
			config = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				settings = {
					["csharp|completion"] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_provide_regex_completions = true,
					},
				},
			},
		},
	},
}
