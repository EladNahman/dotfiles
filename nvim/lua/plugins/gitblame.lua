return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	config = function()
		vim.api.nvim_set_keymap('n', '<leader>oc', ':GitBlameOpenCommitURL<CR>',
			{ noremap = true, silent = true, desc = "Open commit URL in browser" })
		vim.api.nvim_set_keymap('n', '<leader>ogf', ':GitBlameOpenFileURL<CR>',
			{ noremap = true, silent = true, desc = "Open file URL in browser" })
		require('gitblame').setup {
			date_format = "%x",
			message_template = " <author> | <date> - <summary> "
		}
	end
}
