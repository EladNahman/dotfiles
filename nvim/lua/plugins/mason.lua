return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	config = function()
		local mason = require("mason")
		local registry = require("mason-registry")

		mason.setup()

		local servers = {
			"lua-language-server",
			"typescript-language-server",
			"gopls",
			"bash-language-serser",
			"clangd",
			"rust-analyzer"
		}

		for _, name in ipairs(servers) do
			local ok, pkg = pcall(registry.get_package, name)
			if ok and not pkg:is_installed() then
				pkg:install()
			end
		end
	end,
}
