return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		notification = {
			window = {
				winblend = 0, -- set to 0 for solid bg, matches Catppuccin well
			},
		},
	},
}
