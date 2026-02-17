return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "Decodetalkers/csharpls-extended-lsp.nvim" },
		},
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				csharp_ls = {},
			},
		},
	},
	{
		"Decodetalkers/csharpls-extended-lsp.nvim",
		lazy = false,
		config = function()
			require("csharpls_extended").buf_read_cmd_bind()
		end,
	},
}
