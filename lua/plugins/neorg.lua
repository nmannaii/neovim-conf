return {
  {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    dependencies = {
      "nvim-neorg/tree-sitter-norg",
      "nvim-neorg/tree-sitter-norg-meta",
    },
    config = function()
      require("neorg").setup {
        load = {
          ["core.integrations.nvim-cmp"] = {},
          ["core.defaults"] = {},
          ["core.export"] = {
            config = {
              export_dir = "/home/najmedine-mannaii/notes/exports"
            }
          },
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
              },
              default_workspace = "notes",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
        },
      }
    end,
  },
  {
    "dhruvasagar/vim-table-mode",
    lazy = false,
  }
}
