return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  config = function()
    require("ufo").setup {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    }
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, {desc = "Open all fold"})
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, {desc = "Close all fold"})
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, {desc = "Open fold excep kinds"})
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, {desc = "Close folds with"}) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
