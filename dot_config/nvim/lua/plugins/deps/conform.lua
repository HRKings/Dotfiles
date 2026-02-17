return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			kulala = {
				command = "kulala-fmt",
				args = { "format", "$FILENAME" },
				stdin = false,
			},
			topiary_nu = {
				command = "topiary",
				args = { "format", "--language", "nu" },
			},
		},
		formatters_by_ft = {
			http = { "kulala" },
			nu = { "topiary_nu" },
		},
	},
}
