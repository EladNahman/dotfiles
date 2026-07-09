return {
	{
		"esmuellert/nvim-eslint",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
		opts = function()
			return {
				settings = {
					format = true,
					workingDirectory = { mode = "location" },
					nodePath = nil,
				},
			}
		end,
		config = function(_, opts)
			require("nvim-eslint").setup(opts)
		end,
	},
}
