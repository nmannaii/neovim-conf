vim.api.nvim_create_user_command("CodeRun", function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local json = require("plenary.json")
  local overseer = require("overseer")
  local conf = require("telescope.config").values

  local launch_json = vim.fs.find("launch.json", { path = vim.loop.cwd(), type = "file" })
  if #launch_json == 0 then
    print("no launch.json file found")
    return
  end

  local lines = vim.fn.readfile(launch_json[1])
  local content = vim.json.decode(json.json_strip_comments(table.concat(lines, "\n")))
  local configurations = content["configurations"]

  pickers
    .new({}, {
      prompt_title = "Select projects to run",
      finder = finders.new_table({
        results = configurations,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        -- Override default <CR> action
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          local results = {}

          if vim.tbl_isempty(multi) then
            -- nothing marked → take current entry
            table.insert(results, action_state.get_selected_entry())
          else
            results = multi
          end

          for _, entry in ipairs(results) do
            local task = overseer.new_task({
              name = "C#: " .. entry.display,
              cmd = { "dotnet" },
              args = {
                "run",
                "--configuration",
                "Debug",
                "--project",
                entry.value.projectPath:gsub("${workspaceFolder}", vim.fn.getcwd()),
              },
              cwd = vim.fn.getcwd(),
              components = {
                "default",
              },
            })
            task:start()
          end
          actions.close(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end, {})

vim.api.nvim_create_user_command("TasksPID", function()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ status = "RUNNING" })
  local result = {}
  for _, task in pairs(tasks) do
    table.insert(result, { name = task.name, PID = vim.fn.jobpid(task.strategy.chan_id) })
  end
  print(vim.inspect(result))
end, {})
