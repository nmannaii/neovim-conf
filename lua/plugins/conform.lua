return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      html = { "html-beautify-custom" },
      htmlangular = { "htmlangular-beautify-custom" },
      cs = { "csharpier" },
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
      csharpier = {
        command = "dotnet-csharpier",
        args = { "--write-stdout" },
      },
    },
  },
}
