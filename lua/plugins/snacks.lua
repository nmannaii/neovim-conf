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
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    snacks.setup {
      explorer = { enabled = true },
      picker = { enabled = true, ui_select = true },
      indent = { enabled = true },
      notifier = { enabled = true },
      statuscolumn = { enabled = true },
      zen = { enabled = true },
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

    local map = vim.keymap.set
    map("n", "<leader>sh", function()
      snacks.picker.help()
    end, { desc = "[S]earch [H]elp" })
    map("n", "<leader>sk", function()
      snacks.picker.keymaps()
    end, { desc = "[S]earch [K]eymaps" })
    map("n", "<leader>sc", function()
      snacks.picker.commands()
    end, { desc = "[S]earch [C]ommands" })
    map("n", "<leader>ff", function()
      snacks.picker.files()
    end, { desc = "[S]earch [F]iles" })
    map("n", "<leader>e", function()
      snacks.explorer.open()
    end, { desc = "[F]iles [E]xplorer open tree" })
    map("n", "<leader>sf", function()
      snacks.picker.smart()
    end, { desc = "[S]earch [F]iles" })
    map("n", "<leader>ss", function()
      snacks.picker.pickers()
    end, { desc = "[S]earch [S]elect snacks" })
    map({ "n", "x" }, "<leader>sw", function()
      snacks.picker.grep_word()
    end, { desc = "[S]earch current [W]ord" })
    map("n", "<leader>/", function()
      snacks.picker.grep()
    end, { desc = "[S]earch by [G]rep" })
    map("n", "<leader>fp", function()
      snacks.picker.projects()
    end, { desc = "[S]earch [P]rojects" })
    map("n", "<leader>sd", function()
      snacks.picker.diagnostics()
    end, { desc = "[S]earch [D]iagnostics" })
    map("n", "<leader>s.", function()
      snacks.picker.recent()
    end, { desc = '[S]earch Recent Files ("." for repeat)' })
    map("n", "<leader><leader>", function()
      snacks.picker.buffers()
    end, { desc = "[ ] Find existing buffers" })
    map("n", "<leader>sl", function()
      snacks.picker.lines {}
    end, { desc = "[/] Fuzzily search in current buffer" })
    map("n", "<leader>sb", function()
      snacks.picker.grep_buffers()
    end, { desc = "[S]earch [/] in Open Files" })
    map("n", "<leader>sn", function()
      snacks.picker.files { cwd = vim.fn.stdpath "config" }
    end, { desc = "[S]earch [N]eovim files" })
    map("n", "<C-\\>", function()
      snacks.zen()
    end, { desc = "Toggle [Z]en mode" })
  end,
}
