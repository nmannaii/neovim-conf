return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- Disable nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "htmlangular",
        "csharp",
      },
    },
  },
  -- lazy.nvim
  {
    "GustavEikaas/easy-dotnet.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    config = function()
      require("easy-dotnet").setup {
        debug = {},
        notifications = {
          handler = false,
        },
      }
    end,
  },
}
