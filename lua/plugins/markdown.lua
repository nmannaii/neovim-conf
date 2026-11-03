-- Notes live as markdown in ~/md_notes (render-markdown + the LazyVim markdown extra).
-- Preview: typeset.nvim (nmannaii/typeset.nvim), a typeset copy of the buffer in a split that
-- follows the cursor; terminal-browser.nvim stays for browsing pages (:TerminalBrowser).

-- Pandoc export, with mermaid blocks rendered by pandoc/mermaid.lua (embedded as images).
local function export()
  local formats = {
    { label = "HTML (self-contained)", ext = "html", args = { "--standalone", "--embed-resources" } },
    { label = "PDF", ext = "pdf", args = { "--pdf-engine=xelatex" } }, -- xelatex: unicode-safe
    { label = "Word", ext = "docx", args = {} },
  }
  vim.ui.select(formats, {
    prompt = "Export format",
    format_item = function(f)
      return f.label
    end,
  }, function(f)
    if not f then
      return
    end
    vim.cmd("silent update") -- pandoc reads the file from disk
    local file = vim.api.nvim_buf_get_name(0)
    local target = vim.fn.fnamemodify(file, ":p:r") .. "." .. f.ext
    local cmd = {
      "pandoc",
      file,
      "-f",
      "gfm",
      "-o",
      target,
      "--lua-filter=" .. vim.fn.stdpath("config") .. "/pandoc/mermaid.lua",
      "--resource-path=" .. vim.fn.fnamemodify(file, ":p:h"), -- resolve relative image links
    }
    vim.list_extend(cmd, f.args)
    vim.notify("Exporting to " .. vim.fn.fnamemodify(target, ":~:."), vim.log.levels.INFO, { title = "Markdown" })
    vim.system(cmd, { text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify("Exported " .. vim.fn.fnamemodify(target, ":~:."), vim.log.levels.INFO, { title = "Markdown" })
        else
          vim.notify(res.stderr, vim.log.levels.ERROR, { title = "Markdown export failed" })
        end
      end)
    end)
  end)
end

-- No diagnostics in markdown: notes aren't linted, and marksman's warnings
-- (broken links, duplicate headings) are hidden too. marksman stays for navigation / completion.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_no_diagnostics", { clear = true }),
  pattern = { "markdown", "markdown.mdx" },
  callback = function(ev)
    vim.diagnostic.enable(false, { bufnr = ev.buf })
  end,
})

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    -- A function, since a deep-merged `markdown = {}` would keep the extra's markdownlint-cli2.
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
    end,
  },
  {
    -- terminal-browser inside a Neovim window, for browsing pages.
    "nmannaii/terminal-browser.nvim",
    cmd = { "TerminalBrowser", "TerminalBrowserClose" },
    opts = {},
  },
  {
    -- Replaced by typeset.nvim's preview (<leader>cp below).
    "iamcco/markdown-preview.nvim",
    enabled = false,
  },
  {
    -- A live, typeset preview of the markdown buffer in a split (typst + Rust mermaid; no
    -- browser, no node).
    "nmannaii/typeset.nvim",
    ft = "markdown",
    cmd = { "Typeset", "TypesetInstall" },
    build = function()
      require("typeset.build").install({ sync = true })
    end,
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>Typeset<cr>", desc = "Markdown Preview (typeset)" },
      { "<leader>ce", ft = "markdown", export, desc = "Export (pandoc, with mermaid)" },
      { "<leader>ci", ft = "markdown", "<cmd>Typeset inline<cr>", desc = "Toggle Inline Typeset" },
      { "<leader>cP", ft = "markdown", "<cmd>Typeset overlay<cr>", desc = "Markdown Preview (full screen)" },
    },
    opts = {
      max_width = 400, -- default 120 would stop images filling a full-width preview
      -- Inline typeset stays off until toggled with <leader>ci (:Typeset inline).
    },
  },
  {
    -- snacks.image keeps rendering images and math in documents, but not ```mermaid blocks:
    -- diagrams are the preview's job.
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          -- No per-language switch, and its query uses `; extends` so a config query can't drop the
          -- pattern. `_img` returning nil is how snacks itself skips math when math is disabled.
          local doc = require("snacks.image.doc")
          local img = doc._img
          doc._img = function(ctx)
            if ctx.lang ~= "mermaid" then
              return img(ctx)
            end
          end
        end,
      })
    end,
    opts = {
      image = {
        enabled = true,
        doc = {
          max_width = 120, -- cells; default 80/40 squeezes large images until they are unreadable
          max_height = 60,
        },
      },
    },
  },
}
