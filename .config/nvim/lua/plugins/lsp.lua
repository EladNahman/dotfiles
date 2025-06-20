return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
				  library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				  },
				},
			},
			"hrsh7th/cmp-nvim-lsp"
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local on_attach = function(_, bufnr)
			  local bufopts = { noremap = true, silent = true, buffer = bufnr }
			  local map = vim.keymap.set
			  map("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
			  map("n", "K", vim.lsp.buf.hover, bufopts)
			  map("n", "gD", vim.lsp.buf.declaration, bufopts)
			  map("n", "gd", vim.lsp.buf.definition, bufopts)
			  map("n", "gi", vim.lsp.buf.implementation, bufopts)
			  map("n", "go", vim.lsp.buf.type_definition, bufopts)
			  map("n", "gr", vim.lsp.buf.references, bufopts)
			  map("n", "<leader>e", vim.diagnostic.open_float, bufopts)
			  map("n", "<leader>.", vim.lsp.buf.code_action, bufopts)
			  map("n", "<leader>r", vim.lsp.buf.rename, bufopts)
			end

			local servers = { "lua_ls", "ts_ls", "gopls" }

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					on_attach = on_attach,
					capabilities = capabilities
				})
			end
		end,
	}
}
