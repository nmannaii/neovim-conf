-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      local snacks = require "snacks"
      snacks.setup {
        explorer = { enabled = true },
        picker = { enabled = true, ui_select = true },
        indent = { enabled = true },
        notifier = { enabled = true },
        statuscolumn = { enabled = false },
        zen = { enabled = false },
        terminal = {
          win = {
            keys = {
              nav_h = { "<C-h>", term_nav "h", desc = "Go to Left Window", expr = true, mode = "t" },
              nav_j = { "<C-j>", term_nav "j", desc = "Go to Lower Window", expr = true, mode = "t" },
              nav_k = { "<C-k>", term_nav "k", desc = "Go to Upper Window", expr = true, mode = "t" },
              nav_l = { "<C-l>", term_nav "l", desc = "Go to Right Window", expr = true, mode = "t" },
              hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
              hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
            },
          },
        },
      }
    end,
  },
}
