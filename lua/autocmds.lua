require "nvchad.autocmds"

-- 1. Create a group to prevent duplicate autocommands when sourcing configs
local norg_ft_gpe = vim.api.nvim_create_augroup("NeorgWrapSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = norg_ft_gpe,
  pattern = { "norg" }, -- Filetypes to target
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 120
    vim.keymap.set("n", "<leader>cf", "gg=G", {
      buffer = true,
      desc = "Format using =",
    })
  end,
})
