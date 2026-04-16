return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured",

    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        -- let the plugin lazy load itself
        lazy = false,
        version = "1.*",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
      },
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
    },

    opts = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

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
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dap-view").toggle({}) end, desc = "Dap View" },
      { "<leader>dW", ":DapViewWatch<cr>",                           desc = "Dap View Watch" },
    },
    opts = {
    },
    config = function(_, opts)
      local dap = require("dap")
      local dap_view = require("dap-view")
      dap_view.setup({
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
      })
      dap_view.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dap_view.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap_view.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap_view.close()
      end
    end,
  },
}
