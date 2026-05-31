require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "protols",
  "cssls",
  "angularls",
  "lua_ls",
  "tsgo",
  "eslint",
  "jsonls",
  "marksman",
}

-- protols
vim.lsp.config("protols", {
	cmd = {
		"protols",
		"-i=" .. vim.fn.getcwd() .. "/Proto",
	},
})

vim.lsp.enable(servers)

-- Keymaps + built-in completion on every LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end

		local map = function(keys, fn, desc)
			vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = "LSP: " .. desc })
		end

		map("K", vim.lsp.buf.hover, "Hover docs")
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
		map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next diagnostic")

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("gr", function()
			require("telescope.builtin").lsp_references()
		end, "[G]oto [R]eferences")
		map("gi", function()
			require("telescope.builtin").lsp_implementations()
		end, "[G]oto [I]mplementation")
		map("gd", function()
			require("telescope.builtin").lsp_definitions()
		end, "[G]oto [D]efinition")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("gO", function()
			require("telescope.builtin").lsp_symbols()
		end, "Open Document Symbols")
		map("gW", function()
			require("telescope.builtin").lsp_workspace_symbols()
		end, "Open Workspace Symbols")
		map("gt", function()
			require("telescope.builtin").lsp_type_definitions()
		end, "[G]oto [T]ype Definition")
	end,
})
