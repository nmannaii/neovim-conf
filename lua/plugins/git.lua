return {
  "mason-org/mason.nvim",
  keys = {
    {
      "<leader>gg",
      function()
        vim.fn.jobstart({
          "tmux",
          "display-popup",
          "-d",
          "#{pane_current_path}",
          "-w",
          "95%",
          "-h",
          "95%",
          "-E",
          "lazygit",
        })
      end,
      desc = "Tmux lazygit",
    },
    {
      "<leader>gG",
      false
    }
  },
}
