return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	config = function()
		require("telescope").setup {
			defaults = {
				file_ignore_patterns = {
					"node_modules", "build", "dist", ".git",
				},
			},
		}

		local map = vim.keymap.set
		local function o(desc) return { noremap = true, silent = true, desc = desc } end
		map("n", "<leader>gs", require("telescope.builtin").git_status, o("Git status (Telescope)"))
		map("n", "<leader>of", require("telescope.builtin").oldfiles, o("Recent files"))
		map("n", "<leader>ff", require("telescope.builtin").find_files, o("Find files"))
		map("n", "<leader>fs", require("telescope.builtin").live_grep, o("Live grep"))
		map("n", "gi", require("telescope.builtin").lsp_implementations, o("LSP: implementations"))
		map("n", "gr", require("telescope.builtin").lsp_references, o("LSP: references"))
		map("n", "gt", require("telescope.builtin").lsp_type_definitions, o("LSP: type definitions"))
		map("n", "gd", require("telescope.builtin").lsp_definitions, o("LSP: definitions"))
		map("n", "<leader>w", require("telescope.builtin").lsp_workspace_symbols, o("LSP: workspace symbols"))
	end,
}
