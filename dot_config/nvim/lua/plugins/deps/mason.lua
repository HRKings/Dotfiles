return {
	"mason-org/mason.nvim",
	opts = function(_, opts)
		vim.list_extend(opts.ensure_installed, {
			"html-lsp",
			"tailwindcss-language-server",
			"harper-ls",
		})
	end,
}
