----------------------
---- Vscode extension download url
---- https://ms-dotnettools.gallery.vsassets.io/_apis/public/gallery/publisher/ms-dotnettools/extension/csharp/2.148.23/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=linux-x64
---------------------
return {
  {
    "rcarriga/nvim-dap-ui",
    enabled = false,
  },
  {
    "igorlfs/nvim-dap-view",
    lazy = false,
    config = function()
      local dap_view = require("dap-view")

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
      local vscode = require("dap.ext.vscode")
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

      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      dap_view.setup({
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
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
      local dap = require("dap")
      local widgets = require("dap.ui.widgets")
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
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

      -- nvim-dap spawns `command` with the debuggee's argv appended directly
      -- (no shell), so there's no single herdr subcommand that maps onto
      -- `tmux new-window <argv...>`. herdr-terminal.sh does it in two steps:
      -- `herdr tab create` then `herdr pane run` with the quoted argv.
      dap.defaults.fallback.external_terminal = {
        command = vim.fn.stdpath("config") .. "/scripts/herdr-terminal.sh",
        args = {},
      }
      -- dap.defaults.fallback.external_terminal = {
      --   command = "kitty",
      --   args = { "--hold" },
      -- }

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
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
      -- vsdbg-ui
      --
      -- vsdbg-ui sends the DAP `runInTerminal` reverse request, so nvim-dap
      -- spawns the herdr tab itself via `dap.defaults.fallback.external_terminal`
      -- (herdr-terminal.sh, configured above). nvim-dap refuses to let an
      -- adapter override its own built-in `runInTerminal` handler (it errors
      -- on the duplicate key), and the reverse request's `body.env` arrives
      -- empty anyway -- so herdr-terminal.sh can't be told the config's name
      -- through the request itself. Instead, `dap.adapters.coreclr` is a
      -- function so it runs *before* the session is even created: it exports
      -- HERDR_DAP_LABEL into Neovim's own environment, which
      -- launch_external_terminal() (dap/session.lua) inherits into the
      -- spawned herdr-terminal.sh, which uses it as the tab's `--label`.
      -----------------------------------------------------------------------

      -- Handshake code
      local rpc = require("dap.rpc")

      local function send_payload(client, payload)
        local msg = rpc.msg_with_content_length(vim.json.encode(payload))
        client.write(msg)
      end

      function RunHandshake(self, request_payload)
        local response = {
          type = "response",
          seq = 0,
          command = "handshake",
          request_seq = request_payload.seq,
          success = true,
          body = {
            signature = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
          },
        }
        send_payload(self.client, response)
      end

      -- END Handshake

      dap.adapters.coreclr = function(callback, config)
        vim.fn.setenv("HERDR_DAP_LABEL", config.name or "debug")
        callback({
          id = "coreclr",
          type = "executable",
          command = "/home/najmedine-mannaii/vsdbg/vsdbg-ui",
          args = { "--interpreter=vscode", "--engineLogging=/home/najmedine-mannaii/Documents/vsdbg.log" },
          options = {
            externalTerminal = true,
          },
          runInTerminal = true,
          reverse_request_handlers = {
            handshake = RunHandshake,
          },
        })
      end

      -----------------------------------------------------------------------
      -- OLD SETUP: netcoredbg + herdr external console. Kept commented out
      -- for reference.
      --
      -- netcoredbg has no `runInTerminal` reverse request, so instead of letting
      -- nvim-dap spawn the terminal, netcoredbg itself is started inside a new
      -- herdr tab in server mode and we connect to it over TCP. Needs a
      -- netcoredbg built with:
      --   --no-redirect         debuggee inherits netcoredbg's stdio, so its
      --                         console IS that herdr tab (stdin included)
      --   --server=0            OS picks a free port -- no collisions when
      --                         several projects are debugged at the same time
      --   --server-port-file=F  netcoredbg reports the port it really got
      -----------------------------------------------------------------------
      -- -- Auto-close the herdr tab created for the debuggee's console once the
      -- -- session ends, instead of leaving it sitting at the "press enter" prompt.
      -- -- The tab id lives on session.config (set in dap.adapters.coreclr below)
      -- -- rather than an upvalue here, so concurrent sessions each close their
      -- -- own tab instead of racing over a shared variable.
      -- local function close_herdr_tab(session)
      -- local tab_id = session.config and session.config.herdr_tab_id
      -- if not tab_id then
      -- return
      -- end
      -- session.config.herdr_tab_id = nil
      -- vim.fn.system { "herdr", "tab", "close", tab_id }
      -- end
      --
      -- dap.listeners.after.event_terminated["herdr-tab-close"] = close_herdr_tab
      -- dap.listeners.after.event_exited["herdr-tab-close"] = close_herdr_tab
      -- dap.listeners.after.disconnect["herdr-tab-close"] = close_herdr_tab
      -- dap.listeners.after.terminate["herdr-tab-close"] = close_herdr_tab
      --
      -- local NETCOREDBG = vim.fn.expand "~/.netcoredbg/netcoredbg"
      --
      -- -- Name the herdr tab after the project being debugged: the assembly from the
      -- -- launch config (`Foo/bin/Debug/net8.0/Foo.dll` -> `Foo`), falling back to the
      -- -- name of the cwd when the config carries no usable `program`.
      -- local function project_name(config)
      -- local program = type(config.program) == "string" and config.program or nil
      -- if program then
      -- local name = vim.fn.fnamemodify(program, ":t:r")
      -- -- guard against an unexpanded `${workspaceFolder}`-style config variable
      -- if name ~= "" and not name:find "%${" then
      -- return name
      -- end
      -- end
      -- return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      -- end
      --
      -- dap.adapters.coreclr = function(callback, config)
      -- local port_file = vim.fn.tempname()
      -- local cwd = vim.fn.getcwd()
      -- local win_name = project_name(config)
      --
      -- local cmd = string.format(
      -- "%s --server=0 --server-port-file=%s --interpreter=vscode --no-redirect"
      -- .. "; echo; read -p '[debug session ended, press enter] '",
      -- vim.fn.shellescape(NETCOREDBG),
      -- vim.fn.shellescape(port_file)
      -- )
      --
      -- local create_out = vim.fn.system {
      -- "herdr",
      -- "tab",
      -- "create",
      -- "--cwd",
      -- cwd,
      -- "--label",
      -- win_name,
      -- "--no-focus",
      -- }
      -- if vim.v.shell_error ~= 0 then
      -- return callback(nil, "herdr tab create failed (is the herdr server running?): " .. create_out)
      -- end
      --
      -- local decode_ok, decoded = pcall(vim.json.decode, create_out)
      -- local pane_id = decode_ok and vim.tbl_get(decoded, "result", "root_pane", "pane_id")
      -- if not pane_id then
      -- return callback(nil, "herdr tab create returned no pane_id: " .. create_out)
      -- end
      -- config.herdr_tab_id = vim.tbl_get(decoded, "result", "root_pane", "tab_id")
      --
      -- vim.fn.system { "herdr", "pane", "run", pane_id, cmd }
      -- if vim.v.shell_error ~= 0 then
      -- return callback(nil, "herdr pane run failed for pane " .. pane_id)
      -- end
      --
      -- -- netcoredbg writes the port file after bind()/listen() but before accept(),
      -- -- so as soon as the file exists the port is bound and waiting for us.
      -- local ok = vim.wait(5000, function()
      -- return vim.fn.filereadable(port_file) == 1
      -- end, 50)
      -- if not ok then
      -- return callback(nil, "netcoredbg did not report a port -- see the '" .. win_name .. "' herdr tab")
      -- end
      --
      -- local port = tonumber(vim.fn.readfile(port_file)[1])
      -- vim.fn.delete(port_file)
      -- if not port then
      -- return callback(nil, "could not read a port from " .. port_file)
      -- end
      --
      -- callback { type = "server", host = "127.0.0.1", port = port }
      -- end

      dap.set_log_level("trace")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    opts = {},
  },
}
