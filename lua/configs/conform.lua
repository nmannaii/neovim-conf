local options = {
  formatters_by_ft = {
    html = { "html-beautify-custom" },
    htmlangular = { "htmlangular-beautify-custom" },
    cs = { lsp_format = "fallback" },
    lua = { "stylua" },
    typescript = { lsp_format = "fallback" },
  },
  formatters = {
    ["html-beautify-custom"] = {
      command = "js-beautify",
      args = {
        "--type",
        "html",
        "--templating",
        "angular",
        "--wrap-attributes",
        "force-aligned",
        "--indent-size",
        "2",
      },
      stdin = true,
    },
    ["htmlangular-beautify-custom"] = {
      command = "js-beautify",
      args = {
        "--type",
        "html",
        "--templating",
        "angular",
        "--wrap-attributes",
        "force-aligned",
        "--indent-size",
        "2",
      },
      stdin = true,
    },
  },
}

return options
