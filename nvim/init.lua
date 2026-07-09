vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.termguicolors = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4;
vim.o.shiftwidth = 4;

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		vim.lsp.buf.format()
	end
})

require("config.lazy")
