vim.opt.relativenumber = true
vim.o.confirm = true

if vim.fn.executable("rg") == 1 then -- Use rg for grep
	vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

vim.opt.shiftwidth = 2 -- 2 spaces for tabs
vim.opt.expandtab = true
vim.opt.tabstop = 2

vim.schedule(function() -- Use system clipboard
	vim.o.clipboard = "unnamedplus"
end)

vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz") -- recenter down motion
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz") -- recenter up motion
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })

vim.diagnostic.config({ virtual_text = true, signs = { text = { " ", " ", " ", " " } } })
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Open diagnostic location list" })
vim.cmd("packadd cfilter") -- filtering quickfix and location list
vim.keymap.set("n", "<leader>q", "<cmd>cw<cr>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>l", "<cmd>lw<cr>", { desc = "Open location list" })

---@type LazySpec[]
local plugins = { -- Plugins via Lazy Package Manager
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{ "nvim-mini/mini.basics", opts = {} },
	{ "nvim-mini/mini.icons", opts = {} },
	{ "nvim-mini/mini.ai", opts = {} },
	{ "nvim-mini/mini.pairs", opts = {} },
	{ "nvim-mini/mini.surround", opts = {} },
	{ "nvim-mini/mini.bracketed", opts = {} },
	{ "nvim-mini/mini.statusline", opts = {} },
	{ "nvim-mini/mini.tabline", opts = {} },
	{
		"nvim-mini/mini.diff",
		lazy = false,
		opts = { view = { style = "number" } },
		keys = { { "<leader>ghp", "<cmd>lua MiniDiff.toggle_overlay()<cr>", desc = "Preview Hunk" } },
	},
	{
		"nvim-mini/mini.clue",
		config = function(_, _)
			local gen_clues = require("mini.clue").gen_clues
			require("mini.clue").setup({
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
					gen_clues.builtin_completion(),
					gen_clues.g(),
					gen_clues.marks(),
					gen_clues.registers(),
					gen_clues.windows(),
					gen_clues.z(),
				},
				window = { delay = 200 },
			})
		end,
	},
	{
		"nvim-mini/mini.pick",
		dependencies = { "nvim-mini/mini.extra", opts = {} },
		config = function(_, _)
			require("mini.pick").setup()
			vim.ui.select = MiniPick.ui_select
			MiniPick.registry.config = function(local_opts, opts)
				MiniPick.builtin.files(
					local_opts or {},
					vim.tbl_extend("force", opts or {}, { source = { name = "config", cwd = "~/dotfiles" } })
				)
			end
			MiniPick.registry.todos = function(local_opts, opts)
				MiniPick.builtin.grep(
					vim.tbl_extend("force", local_opts or {}, { pattern = "TODO|FIXME|NOTE|BUG|HACK" }),
					opts or {}
				)
			end
		end,
		keys = {
			{ "<leader>e", "<cmd>Pick explorer<cr>", desc = "File Explorer" },
			{ "<leader>sf", "<cmd>Pick files<cr>", desc = "Search Files" },
			{ "<leader>sr", "<cmd>Pick oldfiles<cr>", desc = "Search Recent Files" },
			{ "<leader>sc", "<cmd>Pick config<cr>", desc = "Search Config" },
			{ "<leader>st", "<cmd>Pick todos<cr>", desc = "Search Todo Comments" },
			{ "<leader>/", "<cmd>Pick grep_live<cr>", desc = "Live Grep" },
			{ "<leader>sb", "<cmd>Pick buffers<cr>", desc = "Search Buffers" },
			{ "<leader>sh", "<cmd>Pick help<cr>", desc = "Search Help" },
			{ "<leader>z=", "<cmd>Pick spellsuggest<cr>", desc = "Show spelling suggestions" },
		},
	},
	{
		"nvim-mini/mini.starter",
		dependencies = { "nvim-mini/mini.pick" },
		opts = {
			header = " ",
			footer = "",
			items = {
				{ name = "Find File  ", action = "Pick files", section = "" },
				{ name = "Grep Live  ", action = "Pick grep_live", section = "" },
				{ name = "New File  ", action = "ene | startinsert", section = "" },
				{ name = "Recent Files  ", action = "Pick oldfiles", section = "" },
				{ name = "Config  ", action = "Pick config", section = "" },
				{ name = "Help 󰋖", action = "Pick help", section = "" },
				{ name = "Lazy 󰒲 ", action = "Lazy", section = "" },
				{ name = "Quit  ", action = "qa", section = "" },
			},
			evaluate_single = true,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		init = function() ---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({ auto_install = true, highlight = { enable = true } })
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim", -- Setup LSP servers
		dependencies = { { "mason-org/mason.nvim", opts = {} }, "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ruff",
				"pyright",
				"denols",
				"vtsls",
				"astro",
				"emmet_language_server",
				"gopls",
				"zls",
				"tinymist",
				"marksman",
				"vue_ls",
				"svelte",
			},
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vim.fn.stdpath("data")
					.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
				languages = { "vue" },
				configNamespace = "typescript",
			}
			vim.lsp.config("vtsls", { -- VSCode TypeScript LSP
				root_dir = function(bufnr, ondir)
					if vim.fs.root(bufnr, { "package.json" }) ~= nil then
						ondir(vim.fs.root(bufnr, { "package.json" }))
					end
				end,
				settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin } } } },
			})
			vim.lsp.enable(opts.ensure_installed)
		end,
	},
	{
		"folke/lazydev.nvim", -- Setup Lua LSP for config
		ft = "lua",
		opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
	},
	{
		"stevearc/conform.nvim", -- Formatting
		opts = {
			formatters_by_ft = { lua = { "stylua" } },
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},
	{
		"saghen/blink.cmp", -- Completion engine
		dependencies = { "rafamadriz/friendly-snippets", "folke/lazydev.nvim" },
		build = "cargo build --release",
		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = { lazydev = { module = "lazydev.integrations.blink", score_offset = 100 } },
			},
			signature = { enabled = true },
		},
	},
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then -- Setup Lazy
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
