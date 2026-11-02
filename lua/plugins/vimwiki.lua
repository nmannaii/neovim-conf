return {
  "vimwiki/vimwiki",
  init = function()
    -- Only files under the wiki path are vimwiki; otherwise every .md (e.g. ~/md_notes) gets
    -- ft=vimwiki and loses render-markdown, markdown-preview and the markdown LSP/formatters.
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_list = { {
      path = "~/vimwiki/",
      syntax = "markdown",
      ext = ".md",
    } }
  end,
}
