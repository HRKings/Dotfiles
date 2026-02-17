return {
	{
		"nvim-mini/mini.indentscope",
		opts = {
			symbol = "║",
		},
	},
	{
		"catppuccin/nvim",
		opts = {
			auto_integrations = true,
			integrations = {
				indent_blankline = {
					enabled = true,
					colored_indent_levels = true,
				},
				mini = {
					enabled = true,
					indentscope_color = "lavender",
				},
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			vim.g.rainbow_delimiters = { highlight = highlight }

			require("ibl").setup({
				indent = {
					highlight = highlight,
					char = "▏",
					tab_char = "▏",
				},
				whitespace = {
					highlight = { "CursorColumn", "Whitespace" },
					remove_blankline_trail = true,
				},
				scope = { enabled = false },
			})
		end,
	},
}
