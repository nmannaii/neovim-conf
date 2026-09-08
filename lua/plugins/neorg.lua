return {
  {
    "dhruvasagar/vim-table-mode",
    lazy = false,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "rmd" }, -- Add custom filetypes here if configured
    lazy = false,
    config = function()
      require("mkdnflow").setup {}
    end,
  },
  {
    "the-mayankjha/fk_markdown.nvim",
    lazy = false,
    config = function()
      require("fk_markdown").setup {
        code = {
          enabled = true,

          -- 'wide' or 'compact'
          style = "wide",

          background = {
            enabled = false,
            color = "#181825",
          },

          padding = {
            top = 1,
            bottom = 1,
            left = 1,
            right = 2,
          },

          border = {
            enabled = true,
            type = "dynamic",
            color = "#f38ba8",
          },

          title = {
            enabled = true,
            type = "dynamic",
            color = "#a6e3a1",
          },

          icon = {
            enabled = true,
          },
        },
      }
    end,
  },
  {
    "echaya/neowiki.nvim",
    lazy = false,
    opts = {
      wiki_dirs = {
        { name = "Notes", path = "~/notes" },
      },
      discover_nested_roots = true,
    },
    keys = {
      { "<leader>ww", "<cmd>lua require('neowiki').open_wiki()<cr>", desc = "Open Wiki" },
      { "<leader>wW", "<cmd>lua require('neowiki').open_wiki_floating()<cr>", desc = "Open Wiki in Floating Window" },
      { "<leader>wT", "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>", desc = "Open Wiki in Tab" },
    },
  },
}
