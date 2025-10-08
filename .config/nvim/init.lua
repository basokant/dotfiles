-- Basic Settings
vim.opt.relativenumber = true

if vim.fn.executable("rg") == 1 then -- Use rg for grep
	vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

vim.opt.shiftwidth = 2 -- 2 spaces for tabs
vim.opt.expandtab = true
vim.opt.tabstop = 2

vim.opt.clipboard:append({ "unnamed", "unnamedplus" }) -- system clipboard

vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz") -- recenter down motion
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz") -- recenter up motion
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Install Plugins using Lazy Package Manager
local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{ "echasnovski/mini.nvim" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"mason-org/mason-lspconfig.nvim", -- Setup LSP servers
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"denols",
				"vtsls",
				"astro",
				"emmet_language_server",
				"gopls",
				"zls",
				"pico8_ls",
				"tinymist",
				"marksman",
				"vue_ls",
				"svelte",
			},
		},
		config = function(_, opts)
			vim.lsp.config("vtsls", { -- VSCode TypeScript LSP
				root_dir = function(bufnr, ondir)
					if vim.fs.root(bufnr, { "package.json" }) ~= nil then
						ondir(vim.fs.root(bufnr, { "package.json" }))
					end
				end,
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "@vue/typescript-plugin",
									location = vim.fn.stdpath("data")
										.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
									languages = { "vue" },
									configNamespace = "typescript",
								},
							},
						},
					},
				},
			})
			vim.lsp.enable(opts.ensure_installed)
		end,
	},
	{
		"stevearc/conform.nvim", -- Formatting
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},
	{
		"saghen/blink.cmp", -- Completion engine
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = { sources = { default = { "lsp", "path", "snippets" } } },
	},
}

-- Setup Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)

-- Mini Plugins
require("mini.basics").setup()
require("mini.icons").setup()
require("mini.ai").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.notify").setup({})
require("mini.bracketed").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.diff").setup()

require("mini.sessions").setup({
	directory = vim.fn.stdpath("data") .. "/sessions",
	autoread = false,
	autowrite = false,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function() -- autosave sessions
		local session_name = vim.fn.getcwd()
		MiniSessions.write(session_name, { force = true })
	end,
})

MiniClue = require("mini.clue") -- keybind hints
MiniClue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "z" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},
	clues = {
		MiniClue.gen_clues.builtin_completion(),
		MiniClue.gen_clues.g(),
		MiniClue.gen_clues.marks(),
		MiniClue.gen_clues.registers(),
		MiniClue.gen_clues.windows(),
		MiniClue.gen_clues.z(),
	},
})

MiniFiles = require("mini.files") -- File Tree
MiniFiles.setup()
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Open MiniFiles" })

MiniPick = require("mini.pick") -- Fuzzy Finder / Picker
MiniExtra = require("mini.extra")
MiniPick.setup({
	mappings = {
		send_qf = {
			char = "<C-q>",
			func = function()
				local mappings = MiniPick.get_picker_opts().mappings
				vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
			end,
		},
	},
})
vim.ui.select = MiniPick.ui_select

MiniPick.registry.config = function(local_opts, opts)
	MiniPick.builtin.files(local_opts or {}, vim.tbl_extend("force", opts or {}, { source = { cwd = "~/dotfiles" } }))
end

vim.keymap.set("n", "<leader>ff", MiniPick.builtin.files, { desc = "(f)ind (f)ile" })
vim.keymap.set("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "(f)ind (e)xplorer" })
vim.keymap.set("n", "<leader>fc", MiniPick.registry.config, { desc = "(f)ind (c)onfig file" })
vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "(f)ind (b)uffer" })
vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "(s)earch (h)elp" })
vim.keymap.set("n", "<leader>sd", MiniExtra.pickers.diagnostic, { desc = "(s)earch (d)iagnostics" })
vim.keymap.set("n", "z=", MiniExtra.pickers.spellsuggest, { desc = "show spelling suggestions" })
vim.keymap.set("n", "<leader>sk", MiniExtra.pickers.keymaps, { desc = "(s)earch (k)eymaps" })
vim.keymap.set("n", "<leader>sc", MiniExtra.pickers.commands, { desc = "(s)earch (c)ommands" })
vim.keymap.set("n", "<leader>so", MiniExtra.pickers.options, { desc = "(s)earch (o)ptions" })

MiniStarter = require("mini.starter") -- Dashboard
MiniStarter.setup({
	header = " ",
	footer = "",
	items = {
		{ name = "Find File  ", action = MiniPick.builtin.files, section = "" },
		{ name = "Grep Live  ", action = MiniPick.builtin.grep_live, section = "" },
		{ name = "New File  ", action = "ene | startinsert", section = "" },
		{ name = "Recent Files  ", action = MiniExtra.pickers.oldfiles, section = "" },
		{ name = "Config  ", action = MiniPick.registry.config, section = "" },
		{ name = "Help 󰋖", action = MiniPick.builtin.help, section = "" },
		{ name = "Session Restore ", action = MiniSessions.read, section = "" },
		{ name = "Lazy 󰒲 ", action = "Lazy", section = "" },
		{ name = "Quit  ", action = "qa", section = "" },
	},
	evaluate_single = true,
})

-- Treesitter Highlighting
require("nvim-treesitter.configs").setup({ auto_install = true, highlight = { enable = true } })

-- LSP keybindings
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "(g)oto (d)efinition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "(g)oto (D)eclaration" })
vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "(g)oto (r)eferences" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "(g)oto (I)mplementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "(g)oto T(y)pe" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "(c)ode (a)ction" })
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "(c)ode (l)ens" })

-- Diagnostic
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Quickfix List keybindings
vim.keymap.set("n", "<leader>q", "<cmd>copen<cr>", { desc = "(q)uickfix list" })
vim.keymap.set("n", "<leader>l", "<cmd>lopen<cr>", { desc = "(l)ocation list" })
vim.keymap.set("n", "<leader>dq", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "(d)iagnostic (q)uickfix list" })
vim.keymap.set("n", "<leader>dl", function()
	vim.diagnostic.setlocationlist({ bufnr = 0, open = true })
end, { desc = "(d)iagnostic (l)ocation list" })
