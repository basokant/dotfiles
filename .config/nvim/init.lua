vim.opt.relativenumber = true
vim.o.confirm = true

if vim.fn.executable("rg") == 1 then -- Use rg for grep
	vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

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

local plugins = { ---@type LazySpec[]
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
		"nvim-mini/mini.files",
		lazy = false,
		opts = {},
		keys = { { "<leader>e", "<cmd>lua MiniFiles.open()<cr>", desc = "File Explorer" } },
	},
	{
		"nvim-mini/mini.diff",
		lazy = false,
		opts = { view = { style = "number" } },
		keys = { { "<leader>go", "<cmd>lua MiniDiff.toggle_overlay()<cr>", desc = "Toggle Git Overlay" } },
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
					{ mode = "i", keys = "<C-x>" },
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
				{ name = "Search File  ", action = "Pick files", section = "" },
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
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = "/Users/basokant/Library/pnpm/global/5/node_modules/@vue/language-server",
				languages = { "vue", "javascript", "typescript" },
			}

			vim.lsp.config("vtsls", { -- Fix vtsls running on deno projects
				root_dir = function(bufnr, on_dir)
					local denoRootDir = require("lspconfig.util").root_pattern("deno.json", "deno.json")(bufnr)
					if denoRootDir then
						return nil
					end
					local root_markers = { "package.json", "yarn.lock", "pnpm-lock.yaml", "bun.lock" }
					local project_root = vim.fs.root(bufnr, root_markers)
					if not project_root then
						return
					end
					on_dir(project_root)
				end,
				settings = { vtsls = { enableFormatter = false, tsserver = { globalPlugins = { vue_plugin } } } },
				filetypes = {
					"javascript",
					"typescript",
					"vue",
					"javascriptreact",
					"javascript.jsx",
					"typescriptreact",
					"typescript.tsx",
				},
			})
			vim.lsp.config( -- Fix denols running on typescript node projects
				"denols",
				{ workspace_required = true, root_markers = { "deno.json", "deno.jsonc", "deno.lock" } }
			)

			vim.lsp.enable({
				"lua_ls",
				"ruff",
				"pyright",
				"denols",
				"vtsls",
				"astro",
				"emmet_language_server",
				"gopls",
				"eslint",
				"zls",
				"tinymist",
				"marksman",
				"vue_ls",
				"svelte",
			})
		end,
	},
	{
		"stevearc/conform.nvim", -- Formatting
		opts = { ---@type conform.setupOpts
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},
	{
		"saghen/blink.cmp", -- Completion engine
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "cargo build --release",
		opts = { ---@type blink.cmp.Config
			sources = {
				default = { "lsp", "path", "snippets" },
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
vim.opt.rtp:prepend(lazypath) ---@diagnostic disable-line: undefined-field
require("lazy").setup(plugins)
