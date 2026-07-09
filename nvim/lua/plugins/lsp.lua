return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "luv-meta/library", words = { "vim%.uv" } },
          },
        },
      },
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      ------------------------------------------------------------------
      -- Capabilities (for nvim-cmp completion support)
      ------------------------------------------------------------------
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      ------------------------------------------------------------------
      -- Keymaps + Buffer LSP Attach
      ------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local opts = { noremap = true, silent = true, buffer = bufnr }
          local map = vim.keymap.set

          local function with_desc(desc)
            return vim.tbl_extend("force", opts, { desc = desc })
          end

          map("n", "K", vim.lsp.buf.hover, with_desc("LSP: hover docs"))
          map("n", "<C-k>", vim.lsp.buf.signature_help, with_desc("LSP: signature help"))

          map("n", "gD", vim.lsp.buf.declaration, with_desc("LSP: go to declaration"))

          map("n", "<leader>e", vim.diagnostic.open_float, with_desc("Diagnostics: show float"))

          map("n", "<leader>.", vim.lsp.buf.code_action, with_desc("LSP: code action"))
          map("n", "<leader>r", vim.lsp.buf.rename, with_desc("LSP: rename symbol"))

          map("n", "<leader>cp", function()
            vim.fn.setreg("+", vim.fn.expand("%:p"))
          end, with_desc("Copy full file path to clipboard"))
        end,
      })

      ------------------------------------------------------------------
      -- LSP Servers List
      ------------------------------------------------------------------
      local servers = {
        "lua_ls",
        "ts_ls",
        "gopls",
        "bashls",
        "clangd",
        "sourcekit",
        "pyright",
        "prismals",
        "rust_analyzer",
      }

      ------------------------------------------------------------------
      -- Setup Servers (Neovim 0.11+ Native API)
      ------------------------------------------------------------------
      for _, server in ipairs(servers) do
        -- Register server configuration
        vim.lsp.config(server, {
          capabilities = capabilities,
        })

        -- Enable server autostart
        vim.lsp.enable(server)
      end

      ------------------------------------------------------------------
      -- Optional: Extra Settings for lua_ls (recommended)
      ------------------------------------------------------------------
      ------------------------------------------------------------------
      -- Extra Settings for rust_analyzer
      ------------------------------------------------------------------
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              cfgs = { "windows" },
            },
          },
        },
      })

      ------------------------------------------------------------------
      -- Optional: Extra Settings for lua_ls (recommended)
      ------------------------------------------------------------------
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })
    end,
  },
}

