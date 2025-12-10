return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup()
    vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })
  end,
}
