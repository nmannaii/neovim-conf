local map = vim.keymap.set

-- Window navigation, falling through to the adjacent herdr pane at an edge
-- (herdr has no "previous pane" primitive, so <C-\> stays vim-only)
local function nav_or_herdr(wincmd_key, herdr_direction)
  local win_before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd_key)
  if vim.api.nvim_get_current_win() == win_before then
    vim.system({ "herdr", "pane", "focus", "--direction", herdr_direction })
  end
end

map("n", "<C-h>", function()
  nav_or_herdr("h", "left")
end, { desc = "Go to Left Window / herdr pane" })
map("n", "<C-j>", function()
  nav_or_herdr("j", "down")
end, { desc = "Go to Lower Window / herdr pane" })
map("n", "<C-k>", function()
  nav_or_herdr("k", "up")
end, { desc = "Go to Upper Window / herdr pane" })
map("n", "<C-l>", function()
  nav_or_herdr("l", "right")
end, { desc = "Go to Right Window / herdr pane" })

map("n", "<leader>fo", function()
  Snacks.explorer({ cwd = vim.fn.expand("~/md_notes") })
end, { desc = "Explorer (~/md_notes)" })
