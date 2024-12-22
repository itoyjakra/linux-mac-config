return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- Ensure it loads immediately
		priority = 1100, -- High priority to load the colorscheme early
		config = function()
			require("catppuccin").setup({
				flavour = "auto",
				background = {
					light = "latte",
					dark = "macchiato", --frappe", -- mocha",
				},
				transparent_background = false,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
				},
			})
			-- Apply the colorscheme
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
