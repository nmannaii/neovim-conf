return {
  "MagicDuck/grug-far.nvim",
  lazy = false,
  config = function()
    -- optional setup call to override plugin options
    -- alternatively you can set options with vim.g.grug_far = { ... }
    local grug = require "grug-far"
    grug.setup()
    vim.keymap.set({ "x", "n" }, "<leader>sr", function()
      local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
      grug.open {
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      }
    end, { desc = "Search and Replace" })
  end,
}
