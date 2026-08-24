----------------------
---- Vscode extension download url
---- https://ms-dotnettools.gallery.vsassets.io/_apis/public/gallery/publisher/ms-dotnettools/extension/csharp/2.148.23/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=linux-x64
---------------------
return {
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
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
          sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console", "sessions" },
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
    lazy = false,
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
      -- dap.defaults.fallback.external_terminal = {
      --   command = "kitty",
      --   args = { "--hold" },
      -- }

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
      -----------------------------------------------------------------------
      -- OLD SETUP: vsdbg-ui (proprietary). Kept commented out for reference.
      --
      -- vsdbg-ui sends the DAP `runInTerminal` reverse request, so nvim-dap
      -- spawned the tmux window itself via `dap.defaults.fallback.external_terminal`
      -- (still configured above) and `tmux-rename` renamed the freshly focused
      -- window. netcoredbg does not send `runInTerminal`, and the new adapter
      -- below creates its tmux window detached and already named -- so the
      -- rename listener must stay off, or it would rename nvim's own window.
      -----------------------------------------------------------------------
      -- -----------------------------------------------------------------------
      -- -- Step 2: Rename the captured window once the session starts
      -- -----------------------------------------------------------------------
      -- dap.listeners.before.launch["tmux-rename"] = function(session)
      -- local name = session.config.name or "debug"
      --
      -- os.execute("tmux rename-window '" .. name .. "'")
      -- end
      --
      -- -- Handshake code
      -- local rpc = require "dap.rpc"
      --
      -- local function send_payload(client, payload)
      -- local msg = rpc.msg_with_content_length(vim.json.encode(payload))
      -- client.write(msg)
      -- end
      --
      -- function RunHandshake(self, request_payload)
      -- local response = {
      -- type = "response",
      -- seq = 0,
      -- command = "handshake",
      -- request_seq = request_payload.seq,
      -- success = true,
      -- body = {
      -- signature = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      -- },
      -- }
      -- send_payload(self.client, response)
      -- end
      --
      -- -- END Handshake
      --
      -- dap.adapters.coreclr = {
      -- id = "coreclr",
      -- type = "executable",
      -- -- command = "/home/najmedine-mannaii/.vscode/extensions/ms-dotnettools.csharp-2.110.4-linux-x64/.debugger/vsdbg-ui",
      -- command = "/home/najmedine-mannaii/vsdbg/vsdbg-ui",
      -- -- command = "netcoredbg",
      -- args = { "--interpreter=vscode", "--engineLogging=/home/najmedine-mannaii/Documents/vsdbg.log" },
      -- options = {
      -- externalTerminal = true,
      -- },
      -- runInTerminal = true,
      -- reverse_request_handlers = {
      -- handshake = RunHandshake,
      -- },
      -- }

      -----------------------------------------------------------------------
      -- netcoredbg + tmux external console
      --
      -- netcoredbg has no `runInTerminal` reverse request, so instead of letting
      -- nvim-dap spawn the terminal, netcoredbg itself is started inside a new
      -- tmux window in server mode and we connect to it over TCP. Needs a
      -- netcoredbg built with:
      --   --no-redirect         debuggee inherits netcoredbg's stdio, so its
      --                         console IS that tmux window (stdin included)
      --   --server=0            OS picks a free port -- no collisions when
      --                         several projects are debugged at the same time
      --   --server-port-file=F  netcoredbg reports the port it really got
      -----------------------------------------------------------------------
      local NETCOREDBG = vim.fn.expand "~/.netcoredbg/netcoredbg"

      -- Name the tmux window after the project being debugged: the assembly from the
      -- launch config (`Foo/bin/Debug/net8.0/Foo.dll` -> `Foo`), falling back to the
      -- name of the cwd when the config carries no usable `program`.
      local function project_name(config)
        local program = type(config.program) == "string" and config.program or nil
        if program then
          local name = vim.fn.fnamemodify(program, ":t:r")
          -- guard against an unexpanded `${workspaceFolder}`-style config variable
          if name ~= "" and not name:find "%${" then
            return name
          end
        end
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end

      dap.adapters.coreclr = function(callback, config)
        local port_file = vim.fn.tempname()
        local cwd = vim.fn.getcwd()
        local win_name = project_name(config)

        local cmd = string.format(
          "%s --server=0 --server-port-file=%s --interpreter=vscode --no-redirect"
            .. "; echo; read -p '[debug session ended, press enter] '",
          vim.fn.shellescape(NETCOREDBG),
          vim.fn.shellescape(port_file)
        )

        vim.fn.system { "tmux", "new-window", "-d", "-n", win_name, "-c", cwd, cmd }
        if vim.v.shell_error ~= 0 then
          return callback(nil, "tmux new-window failed (is nvim running inside tmux?)")
        end

        -- netcoredbg writes the port file after bind()/listen() but before accept(),
        -- so as soon as the file exists the port is bound and waiting for us.
        local ok = vim.wait(5000, function()
          return vim.fn.filereadable(port_file) == 1
        end, 50)
        if not ok then
          return callback(nil, "netcoredbg did not report a port -- see the '" .. win_name .. "' tmux window")
        end

        local port = tonumber(vim.fn.readfile(port_file)[1])
        vim.fn.delete(port_file)
        if not port then
          return callback(nil, "could not read a port from " .. port_file)
        end

        callback { type = "server", host = "127.0.0.1", port = port }
      end

      dap.set_log_level "trace"
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    opts = {},
  },
}
