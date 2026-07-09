return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	event = "VeryLazy",
	config = true,
	opts = {
		terminal = {
			provider = "none",
		},
	},
	keys = {
		{ "<leader>a",  nil,                        desc = "AI/Claude Code" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>",  mode = "v",                 desc = "Send selection to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file from tree",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
		-- Server control
		{ "<leader>aS", "<cmd>ClaudeCodeStatus<cr>",     desc = "Claude IDE status" },
		{ "<leader>ax", "<cmd>ClaudeCodeStop<cr>",       desc = "Stop Claude IDE server" },
		{ "<leader>aX", "<cmd>ClaudeCodeStart<cr>",      desc = "Start Claude IDE server" },
	},
}
