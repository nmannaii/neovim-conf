return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    config = function()
      require("easy-dotnet").setup {
        debug = {},
        notifications = {
        },
      }
    end,
  },
}
