return {
  "stevearc/oil.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
  config = function()
    require("oil").setup({
      columns = { "icon" },
    })
    vim.keymap.set("n", "-", require("oil").open)
  end,
}

