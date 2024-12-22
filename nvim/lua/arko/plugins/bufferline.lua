return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"moll/vim-bbye",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs", -- Show only tabpages
				themable = true, -- Allow highlight groups to be overridden
				numbers = "ordinal", -- Display ordinal numbers for tabs
				close_command = "Bdelete! %d", -- Close buffer using :Bdelete
				buffer_close_icon = "✗",
				close_icon = "✗",
				path_components = 1, -- Show only file name
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 30,
				tab_size = 21,
				diagnostics = false, -- Disable diagnostics in the bufferline
				diagnostics_update_in_insert = false,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				persist_buffer_sort = true, -- Preserve custom sorting
				separator_style = { "│", "│" }, -- Custom separator style
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				show_tab_indicators = false,
				indicator = {
					style = "none", -- Disable tab indicators
				},
				icon_pinned = "󰐃",
				sort_by = "tabs", -- Sort by insert order
			},
			highlights = {
				separator = {
					fg = "#434C5E", -- Custom color for separator
				},
				buffer_selected = {
					bold = true,
					italic = false, -- Highlight selected buffer
				},
			},
		})
	end,
}
