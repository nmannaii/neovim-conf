local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Tmux
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })

map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map({ "n", "x" }, "<leader>cf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>x", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- File tree
local function toggle_snacks_explorer()
  -- Check if explorer is open
  local explorer = Snacks.picker.get({ source = "explorer" })[1]

  if explorer ~= nil then
    -- Close it
    Snacks.explorer.open();
  else
    -- Open and reveal current file
    Snacks.explorer.reveal()
  end
end

vim.keymap.set("n", "<leader>e", toggle_snacks_explorer, { desc = "Toggle Explorer" })

-- tabufline
if require("nvconfig").ui.tabufline.enabled then
  map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })

  map("n", "L", function()
    require("nvchad.tabufline").next()
  end, { desc = "buffer goto next" })

  map("n", "H", function()
    require("nvchad.tabufline").prev()
  end, { desc = "buffer goto prev" })

  map("n", "<leader>bd", function()
    require("nvchad.tabufline").close_buffer()
  end, { desc = "buffer close" })

  map("n", "<leader>bo", function()
    Snacks.bufdelete.other()
  end, { desc = "Delete Other Buffers" })
end

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

----------- GIT
local gs = require "gitsigns"
-- Navigation
map("n", "]h", gs.next_hunk, { desc = "Next Hunk" })
map("n", "[h", gs.prev_hunk, { desc = "Prev Hunk" })

-- Actions
map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })

map("v", "<leader>gs", function() -- stage selected hunk
  gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
end, { desc = "Stage hunk" })
map("v", "<leader>gr", function() -- reset selected hunk
  gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
end, { desc = "Reset hunk" })

map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" }) -- stage whole buffer
map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" }) -- unstage whole buffer
map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gbl", function()
  gs.blame_line { full = true }
end, { desc = "Blame line" })
map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
map("n", "<leader>gD", gs.diffthis, { desc = "Diff this" })
map("n", "<leader>gd", function()
  gs.diffthis "~"
end, { desc = "Diff this ~" })

-- Text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })

--- end => gitsigns

--- start => lazygit
--- start => lazygit
map({ "n" }, "<leader>gg", function()
  vim.fn.jobstart {
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
  }
end, { desc = "Open lazy git" })

-- Save / quit
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Telescope
local telescope_builtin = require "telescope.builtin"
local map = vim.keymap.set
map("n", "<leader>sk", function()
  telescope_builtin.keymaps()
end, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sc", function()
  telescope_builtin.commands()
end, { desc = "[S]earch [C]ommands" })
map("n", "<leader>ff", function()
  telescope_builtin.find_files()
end, { desc = "[S]earch [F]iles" })
map({ "n", "x" }, "<leader>sw", function()
  telescope_builtin.grep_string()
end, { desc = "[S]earch current [W]ord" })
map("n", "<leader>/", function()
  telescope_builtin.live_grep()
end, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", function()
  telescope_builtin.diagnostics()
end, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader><leader>", function()
  telescope_builtin.buffers()
end, { desc = "[ ] Find existing buffers" })
map("n", "<leader>sb", function()
  telescope_builtin.current_buffer_fuzzy_find()
end, { desc = "Current buffer fuzzy find" })
