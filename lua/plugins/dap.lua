return {
  {
    "igorlfs/nvim-dap-view",
    config = function()
      local dap_view = require "dap-view"

      local signs = {
        DapBreakpoint = { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" },
        DapBreakpointCondition = { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" },
        DapLogPoint = { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" },
        DapStopped = { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "" },
        DapBreakpointRejected = { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" },
      }

      for name, config in pairs(signs) do
        vim.fn.sign_define(name, config)
      end

      vim.keymap.set("n", "<leader>du", "<cmd>DapViewToggle<cr>", { desc = "Widgets" })

      -- setup dap config by VsCode launch.json file
      local vscode = require "dap.ext.vscode"
      vscode.getconfigs = function(path)
        local resolved_path = path or (vim.fn.getcwd() .. "/.vscode/nvim-launch.json")
        if not vim.loop.fs_stat(resolved_path) then
          return {}
        end
        local lines = {}
        for line in io.lines(resolved_path) do
          if not vim.startswith(vim.trim(line), "//") then
            table.insert(lines, line)
          end
        end
        local contents = table.concat(lines, "\n")
        return vscode._load_json(contents)
      end

      local json = require "plenary.json"
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      dap_view.setup {
        winbar = {
          show = true,
          -- You can add a "console" section to merge the terminal with the other views
          sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
          -- Must be one of the sections declared above
          default_section = "watches",
          -- Append hints with keymaps within the labels
          show_keymap_hints = true,
          base_sections = {
            -- Labels can be set dynamically with functions
            -- Each function receives the window's width and the current section as arguments
            breakpoints = { label = "Breakpoints", keymap = "B" },
            scopes = { label = "Scopes", keymap = "S" },
            exceptions = { label = "Exceptions", keymap = "E" },
            watches = { label = "Watches", keymap = "W" },
            threads = { label = "Threads", keymap = "T" },
            repl = { label = "REPL", keymap = "R" },
            sessions = { label = "Sessions", keymap = "K" },
            console = { label = "Console", keymap = "C" },
          },
          controls = {
            enabled = true,
            position = "right",
            buttons = {
              "play",
              "step_into",
              "step_over",
              "step_out",
              "step_back",
              "run_last",
              "terminate",
              "disconnect",
            },
            custom_buttons = {},
          },
        },
        icons = {
          collapsed = "󰅂 ",
          disabled = "",
          disconnect = "",
          enabled = "",
          expanded = "󰅀 ",
          filter = "󰈲",
          negate = " ",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local widgets = require "dap.ui.widgets"
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end, { desc = "Breakpoint Condition" })

      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = "Toggle Breakpoint" })

      vim.keymap.set("n", "<F5>", function()
        dap.continue()
      end, { desc = "Run/Continue" })

      vim.keymap.set("n", "<C-F10>", function()
        dap.run_to_cursor()
      end, { desc = "Run to Cursor" })

      vim.keymap.set("n", "<leader>dg", function()
        dap.goto_()
      end, { desc = "Go to Line (No Execute)" })

      vim.keymap.set("n", "<F11>", function()
        dap.step_into()
      end, { desc = "Step Into" })

      vim.keymap.set("n", "<leader>dj", function()
        dap.down()
      end, { desc = "Down" })

      vim.keymap.set("n", "<leader>dk", function()
        dap.up()
      end, { desc = "Up" })

      vim.keymap.set("n", "<leader>dl", function()
        dap.run_last()
      end, { desc = "Run Last" })

      vim.keymap.set("n", "<S-F11>", function()
        dap.step_out()
      end, { desc = "Step Out" })

      vim.keymap.set("n", "<F10>", function()
        dap.step_over()
      end, { desc = "Step Over" })

      vim.keymap.set("n", "<leader>dP", function()
        dap.pause()
      end, { desc = "Pause" })

      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.toggle()
      end, { desc = "Toggle REPL" })

      vim.keymap.set("n", "<leader>ds", function()
        dap.session()
      end, { desc = "Session" })

      vim.keymap.set("n", "<leader>dt", function()
        dap.terminate()
      end, { desc = "Terminate" })

      vim.keymap.set("n", "<leader>dw", function()
        widgets.hover()
      end, { desc = "Widgets" })
      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/tmux",
        args = {
          "new-window",
          "-P", -- print info
          "-F",
          "#{window_id}", -- print only the ID
          "-n",
          "debug", -- temporary name
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
      local utils = require "dap.utils"

      local rpc = require "dap.rpc"

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
        local signature = signResult:read "*a"
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
      dap.set_log_level "trace"
    end,
  },
}
