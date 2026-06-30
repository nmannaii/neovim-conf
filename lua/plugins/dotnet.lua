return {
  {
    "nmannaii/easy-dotnet.nvim",
    ft = "cs",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    config = function()
      require("easy-dotnet").setup {
        debug = {
          console = "externalTerminal",
          engine = "netcoredbg",
          apply_value_converters = true,
          auto_register_dap = true,
          mappings = {
            open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
          },
        },
        notifications = {},
      }
    end,
  },
}
