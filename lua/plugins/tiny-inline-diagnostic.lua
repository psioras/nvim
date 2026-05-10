return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "nonerdfont",
			options = {
				show_source = true,
				multilines = true,
				overflow = { mode = "wrap" },
				virt_texts = { priority = 2048 },
				show_all_diags_on_cursorline = true, -- all errors on current line
				enable_on_insert = false,
				-- This is the key one: show diagnostics on every line, not just cursor
				severity_sort = true,
			},
		})
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
		})
	end,
}
