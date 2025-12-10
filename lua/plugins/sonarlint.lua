return {
  url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  config = function()
    require("sonarlint").setup({
      server = {
        cmd = {
          "sonarlint-language-server",
          -- Ensure that sonarlint-language-server uses stdio channel
          "-stdio",
          "-analyzers",
          -- paths to the analyzers you need, using those for python and java in this example
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcsharp.jar"),
        },
        init_options = {
          omnisharpDirectory = vim.fn.expand("$MASON/packages/sonarlint-language-server/extension/omnisharp"),
          csharpOssPath = vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcsharp.jar"),
          csharpEnterprisePath = vim.fn.expand("$MASON/share/sonarlint-analyzers/csharpenterprise.jar"),
        },
        settings = {
          sonarlint = {
            connectedMode = {
              connections = {
                sonarqube = {
                  {
                    connectionId = "https-sonarq-ibelem-com",
                    -- this is the url that will go into get_credentials
                    token = os.getenv("SONARQ_TOKEN"),
                    serverUrl = os.getenv("SONARQ_URL"),
                    disableNotifications = false,
                  },
                },
              },
            },
          },
        },
        connected = {
          get_credentials = function()
            return os.getenv("SONARQ_TOKEN")
          end,
        },
      },
      filetypes = {
        -- Tested and working
        "cs",
        "dockerfile",
        "python",
        "cpp",
        "java",
      },
      before_init = function(params, config)
        config.connected.get_credentials = function()
          return os.getenv("SONARQ_TOKEN")
        end
      end,
    })
  end,
}
