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

-- angularls
local root = '/home/najmedine-mannaii/.nvm/versions/node/v20.9.0/lib/node_modules'

local cmd = { "ngserver", "--stdio", "--tsProbeLocations", root .. '/typescript/lib/', "--ngProbeLocations", root ..
'/@angular/language-server/bin/' }

vim.lsp.config('angularls', {
  cmd = cmd,
  filetypes = { 'html', 'htmlangular', 'typescript' },
  on_attach = function(client, bufnr)
    -- 🚫 turn off features that clash with typescript-tools
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.semanticTokensProvider = nil
    client.server_capabilities.inlayHintProvider = false

    -- ✅ KEEP ONLY WHAT WE NEED:
    -- - referencesProvider  → “Find All References” TS ↔ HTML
    -- - definitionProvider  → “Go to definition” from HTML to TS
    -- - workspaceSymbolProvider → optional
  end,
})
vim.lsp.enable("angularls")

vim.lsp.config("roslyn", {
  on_attach = function()
    print("This will run when the server attaches!")
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cs" },
  callback = function()
    vim.api.nvim_clear_autocmds({
      group = "noice_lsp_progress",
      event = "LspProgress",
      pattern = "*",
    })
  end,
})
