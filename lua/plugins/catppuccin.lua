return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		flavour = "mocha", -- This is the darkest base (dark grey)
		transparent_background = true, -- Set to true if your terminal is already black
		color_overrides = {
			mocha = {
				base = "#000000", -- This makes the main background PITCH BLACK
				mantle = "#010101", -- Slightly lighter for a subtle contrast
				crust = "#000000", -- Bottom bars and corners
			},
		},
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			telescope = {
				enabled = true,
			},
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}
