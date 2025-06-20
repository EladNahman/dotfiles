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
    map("n", "<leader>gs", require("telescope.builtin").git_status, { noremap = true, silent = true })
    map("n", "<leader>of", require("telescope.builtin").oldfiles, { noremap = true, silent = true })
    map("n", "<leader>ff", require("telescope.builtin").find_files, { noremap = true, silent = true })
    map("n", "<leader>fs", require("telescope.builtin").live_grep, { noremap = true, silent = true })
  end,
}

