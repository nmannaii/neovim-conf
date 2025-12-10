return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      })
    end,
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
      filewatching = "roslyn",
      lock_target = true,
      choose_target = function(target)
        return vim.iter(target):find(function(item)
          if string.match(item, "PushManager.sln") then
            return item
          end
        end)
      end,
    },
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function()
  --     require("lspconfig.configs").dotrush = {
  --       default_config = {
  --         cmd = { "/opt/DotnetRush/DotRush" }, -- Adjust path to the DotRush executable
  --         filetypes = { "cs" },
  --         root_dir = function(fname)
  --           return vim.fn.getcwd()
  --         end,
  --       },
  --     }
  --     require("lspconfig").dotrush.setup({})
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/tmux",
        args = {
          "new-window",
          "-P",             -- print info
          "-F", "#{window_id}", -- print only the ID
          "-n", "debug",    -- temporary name
        },
      }

      -----------------------------------------------------------------------
      -- Step 2: Rename the captured window once the session starts
      -----------------------------------------------------------------------
      dap.listeners.before.launch["tmux-rename"] = function(session)
        local name = session.config.name or "debug"

        os.execute("tmux rename-window '" .. name .. "'")
      end

      -- Handshake code
      local utils = require("dap.utils")

      local rpc = require("dap.rpc")

      local function send_payload(client, payload)
        local msg = rpc.msg_with_content_length(vim.json.encode(payload))
        client.write(msg)
      end

      function RunHandshake(self, request_payload)
        local signResult = io.popen("node ~/.config/nvim/vscode-signer.js " .. request_payload.arguments.value)
        print(vim.inspect(signResult))
        if signResult == nil then
          utils.notify("error while signing handshake", vim.log.levels.ERROR)
          return
        end
        local signature = signResult:read("*a")
        signature = string.gsub(signature, "\n", "")
        local response = {
          type = "response",
          seq = 0,
          command = "handshake",
          request_seq = request_payload.seq,
          success = true,
          body = {
            signature = signature,
          },
        }
        send_payload(self.client, response)
      end

      -- END Handshake

      dap.adapters.coreclr = {
        id = "coreclr",
        type = "executable",
        command = "/home/najmedine-mannaii/.vscode/extensions/ms-dotnettools.csharp-2.93.22-linux-x64/.debugger/vsdbg-ui",
        args = { "--interpreter=vscode", "--engineLogging=/home/najmedine-mannaii/Documents/vsdbg.log" },
        options = {
          externalTerminal = true,
        },
        runInTerminal = true,
        reverse_request_handlers = {
          handshake = RunHandshake,
        },
      }
      dap.set_log_level("trace")
    end,
  },
}
