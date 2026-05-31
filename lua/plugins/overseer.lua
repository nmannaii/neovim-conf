return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup()
    vim.keymap.set("n", "<leader>ow", "<cmd>OverseerToggle!<cr>", { desc = "Task list" })
    vim.keymap.set("n", "<leader>oo", "<cmd>OverseerRun<cr>", { desc = "Run task" })
    vim.keymap.set("n", "<leader>ot", "<cmd>OverseerTaskAction<cr>", { desc = "Task action" })
  end,
}
