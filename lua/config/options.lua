-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require("config.dotnet-overseer")
vim.g.autoformat = false
vim.lsp.config("protols", {
  cmd = {
    "protols",
    "-i=" .. vim.fn.getcwd() .. "/Proto",
  },
})
vim.lsp.enable("protols")
vim.lsp.enable("cssls")
vim.lsp.enable("denols")
-- vim.lsp.enable("ts_ls")

-- -- angularls
-- local root = '/home/najmedine-mannaii/.nvm/versions/node/v24.12.0/lib/node_modules'
-- --
-- local cmd = { "ngserver", "--stdio", "--tsProbeLocations", root .. '/typescript/lib/', "--ngProbeLocations", root ..
-- '/@angular/language-server/bin/' }
--
-- vim.lsp.config('angularls', {
--   cmd = function(dispatchers, config)
--     return vim.lsp.rpc.start(cmd, dispatchers)
--   end,
--   -- filetypes = { 'html', 'htmlangular' },
--   on_attach = function(client, bufnr)
--     client.server_capabilities.renameProvider = false;
--   end,
-- })
vim.lsp.enable("angularls")

vim.lsp.config("roslyn", {
  on_attach = function()
  end,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})
-- Roslyn dotnet

local handles = {}

vim.api.nvim_create_autocmd("User", {
  pattern = "RoslynRestoreProgress",
  callback = function(ev)
    local token = ev.data.params[1]
    local handle = handles[token]
    if handle then
      handle:report({
        title = ev.data.params[2].state,
        message = ev.data.params[2].message,
      })
    else
      handles[token] = require("fidget.progress").handle.create({
        title = ev.data.params[2].state,
        message = ev.data.params[2].message,
        lsp_client = {
          name = "roslyn",
        },
      })
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "RoslynRestoreResult",
  callback = function(ev)
    local handle = handles[ev.data.token]
    handles[ev.data.token] = nil

    if handle then
      handle.message = ev.data.err and ev.data.err.message or "Restore completed"
      handle:finish()
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
      vim.api.nvim_create_autocmd("InsertCharPre", {
        desc = "Roslyn: Trigger an auto insert on '/'.",
        buffer = bufnr,
        callback = function()
          local char = vim.v.char

          if char ~= "/" then
            return
          end

          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          row, col = row - 1, col + 1
          local uri = vim.uri_from_bufnr(bufnr)

          local params = {
            _vs_textDocument = { uri = uri },
            _vs_position = { line = row, character = col },
            _vs_ch = char,
            _vs_options = {
              tabSize = vim.bo[bufnr].tabstop,
              insertSpaces = vim.bo[bufnr].expandtab,
            },
          }

          -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
          -- buffer has changed.
          vim.defer_fn(function()
            client:request(
            ---@diagnostic disable-next-line: param-type-mismatch
              "textDocument/_vs_onAutoInsert",
              params,
              function(err, result, _)
                if err or not result then
                  return
                end

                vim.snippet.expand(result._vs_textEdit.newText)
              end,
              bufnr
            )
          end, 1)
        end,
      })
    end
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "cs" },
--   callback = function()
--     vim.api.nvim_clear_autocmds({
--       group = "noice_lsp_progress",
--       event = "LspProgress",
--       pattern = "*",
--     })
--   end,
-- })

-- I always like to prefix my commands with JR so I can easily find them
vim.api.nvim_create_user_command("CodeShot", function()
  -- snag the file type from the buffer
  local file_type = vim.bo.filetype

  -- get the text from the visual selection as a table
  local text = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])

  -- join it together into one string
  local full_text = table.concat(text, "\n")

  -- write the file to /tmp/freeze...probably could find a better place to put this so it's
  -- cross platform, but it works for me ¯\_(ツ)_/¯
  local file_path = "/tmp/freeze." .. file_type
  local file = io.open(file_path, "w")
  if file == nil then
    print("could not open file")
    return
  end
  file:write(full_text)
  file:close()

  -- call the freeze command with the file type we grabbed earlier
  vim.fn.system("freeze " ..
    file_path .. " -o /tmp/freeze.png --font.size 16 --line-height 1.4 --show-line-numbers --window --border.radius 8")

  --  This is the tricky bit. Use apple script to copy the image to the clipboard
  vim.fn.system("wl-copy < /tmp/freeze.png")

  -- notify the user that the image has been copied to the clipboard
  vim.notify("Image copied to clipboard", vim.log.levels.INFO)
end, {
  -- make sure the command is only available in visual mode
  range = true,
})
