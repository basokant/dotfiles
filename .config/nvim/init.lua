vim.opt.relativenumber = true
if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Set tab and indentation
vim.opt.list = false
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Use system clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
vim.opt.termguicolors = true

vim.g.mapleader = " "

-- Keep cursor center in Down and Up motions
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")

local plugins = {
	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},

	-- MINI plugins that cover so much!
	{
		"echasnovski/mini.nvim",
		version = false,
	},

	-- TreeSitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- LSP
	{
		"mason-org/mason.nvim",
		opts = function()
			require("mason").setup()
		end,
	}, -- installs LSP servers
	{ "neovim/nvim-lspconfig" }, -- configures LSPs
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"svelte",
				"gopls",
				"denols",
				"zls",
				"vtsls",
				"astro",
				"emmet_language_server",
				"pico8_ls",
			},
			servers = {
				gleam = {},
				vtsls = {
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								maxInlayHintLength = 30,
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					},
				},
			},
		},
	}, -- links the two above

	-- Some LSPs don't support formatting, this fills the gaps
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},

	-- Snippet collection
	{ "rafamadriz/friendly-snippets" },

	-- Autocomplete engine (LSP, snippets etc)
	-- https://cmp.saghen.dev/configuration/keymap.html#default
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts_extend = { "sources.default" },
		opts = {
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},

	-- Configure LuaLS for NVIM config
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Configure LuaLS for Love2D
	{
		"S1M0N38/love2d.nvim",
		event = "VeryLazy",
		version = "2.*",
		opts = {},
		keys = {
			{ "<leader>v", ft = "lua", desc = "LÖVE" },
			{ "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
			{ "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
		},
	},

	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	-- Pretty Markdown Support
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			heading = { sign = true },
			bullet = { right_pad = 1 },
			quote = { repeat_linebreak = true },
			win_options = {
				showbreak = { default = "", rendered = "  " },
				breakindent = { default = false, rendered = true },
				breakindentopt = { default = "", rendered = "" },
			},
		},
		ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
		config = function(_, opts)
			require("render-markdown").setup(opts)
			vim.keymap.set("n", "<leader>um", function()
				local state = require("render-markdown.state")
				local m = require("render-markdown")

				if state.enabled then
					m.disable()
				else
					m.enable()
				end
			end, { desc = "Toggle Render Markdown" })
		end,
	},
}

-- Setup Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
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

vim.cmd.colorscheme("catppuccin")

require("mini.basics").setup({
	options = {
		extra_ui = true,
	},
})

require("mini.sessions").setup({
	-- directory where sessions are stored
	directory = vim.fn.stdpath("data") .. "/sessions",
	autoread = false, -- we’ll handle loading manually
	autowrite = false, -- disable default auto-write
})

-- Auto-save on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local session_name = vim.fn.getcwd()
		MiniSessions.write(session_name, { force = true })
	end,
})

require("mini.icons").setup()
require("mini.ai").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.jump").setup()
require("mini.jump2d").setup()
require("mini.notify").setup({
	lsp_progress = {
		enable = false,
	},
})
require("mini.bracketed").setup()

require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.diff").setup()

MiniClue = require("mini.clue")
MiniClue.setup({
	triggers = {
		-- Leader triggers
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },

		-- Marks
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },

		-- Registers
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },

		-- Bracketed motions (with mini.bracketed)
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "x", keys = "[" },
		{ mode = "x", keys = "]" },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		MiniClue.gen_clues.builtin_completion(),
		MiniClue.gen_clues.g(),
		MiniClue.gen_clues.marks(),
		MiniClue.gen_clues.registers(),
		MiniClue.gen_clues.windows(),
		MiniClue.gen_clues.z(),
	},

	window = {
		delay = 200,
	},
})

MiniFiles = require("mini.files")
MiniFiles.setup()

vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Open MiniFiles" })

vim.keymap.set("n", "<leader>bd", "<CMD>bd<CR>", { desc = "Close current buffer" })

MiniPick = require("mini.pick")
MiniExtra = require("mini.extra")

-- Centered on screen
local win_config = function()
	local height = math.floor(0.618 * vim.o.lines)
	local width = math.floor(0.618 * vim.o.columns)
	return {
		anchor = "NW",
		height = height,
		width = width,
		row = math.floor(0.5 * (vim.o.lines - height)),
		col = math.floor(0.5 * (vim.o.columns - width)),
	}
end

local function normalize_item(item)
	if type(item) == "string" then
		-- Split on %z (null byte) for grep_live picker
		local tokens = {}
		for token in item:gmatch("([^%z]+)") do
			table.insert(tokens, token)
		end

		if #tokens < 3 then
			return { filename = item, lnum = 1, col = 1, text = text }
		end

		return {
			filename = tokens[1],
			lnum = tonumber(tokens[2]),
			col = tonumber(tokens[3]),
			text = tokens[4] or tokens[1],
		}
	elseif type(item) == "table" then
		return {
			filename = item.path or item.filename or item.file or "",
			lnum = tonumber(item.lnum) or tonumber(item.line) or 1,
			col = tonumber(item.col) or tonumber(item.column) or 1,
			text = item.text or item.line_text or filename,
		}
	end
end

-- Send MiniPick results to quickfix
local function send_to_qflist()
	local items = MiniPick.get_picker_items() or {}
	if vim.tbl_isempty(items) then
		return true
	end

	local qf_items = {}
	for _, item in ipairs(items) do
		table.insert(qf_items, normalize_item(item))
	end

	if vim.tbl_isempty(qf_items) then
		return true
	end

	vim.fn.setqflist(qf_items, "r") -- replace quickfix list
	require("trouble").open("quickfix")
	return true
end

MiniPick.setup({
	window = { config = win_config },
	mappings = {
		send_qf = {
			char = "<C-q>",
			func = send_to_qflist,
		},
	},
})

-- Override Select with MiniPick
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = MiniPick.ui_select

-- Pickers

--- Pick from Config Files
---
--- Lists all config files recursively in all subdirectories. Tries to use one of the
--- CLI tools to create items (see |MiniPick-cli-tools|): `rg`, `fd`, `git`.
--- If none is present, uses fallback which utilizes |vim.fs.dir()|.
---
--- To customize CLI tool search, either use tool's global configuration approach
--- or directly |MiniPick.builtin.cli()| with specific command.
---
---@param local_opts __pick_builtin_local_opts
---   Possible fields:
---   - <tool> `(string)` - which tool to use. One of "rg", "fd", "git", "fallback".
---     Default: whichever tool is present, trying in that same order.
---@param opts __pick_builtin_opts
MiniPick.registry.config = function(local_opts, opts)
	MiniPick.builtin.files(local_opts or {}, vim.tbl_extend("force", opts or {}, { source = { cwd = "~/dotfiles" } }))
end

--- Built-in diagnostic picker
---
--- Pick from |vim.diagnostic| using |vim.diagnostic.get()|.
---
---@param local_opts __extra_pickers_local_opts
---   Possible fields:
---   - <get_opts> `(table)` - options for |vim.diagnostic.get()|. Can be used
---     to limit severity or namespace. Default: `{}`.
---   - <scope> `(string)` - one of "all" (available) or "current" (buffer).
---     Default: "all".
---   - <sort_by> `(string)` - sort priority. One of "severity", "path", "none".
---     Default: "severity".
---@param opts __extra_pickers_opts
---
---@return __extra_pickers_return
MiniPick.builtin.diagnostic = function(local_opts, opts)
	MiniExtra.pickers.diagnostic(
		vim.tbl_extend("force", local_opts or {}, {
			mappings = {
				send_qf = {
					char = "<C-q>",
					func = function()
						require("trouble").open("diagnostics")
					end,
				},
			},
		}),
		opts or {}
	)
end

vim.keymap.set("n", "<leader>ff", MiniPick.builtin.files, { desc = "(f)ind (f)ile" })
vim.keymap.set("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "(f)ind (e)xplorer" })
vim.keymap.set("n", "<leader>fc", MiniPick.registry.config, { desc = "(f)ind (c)onfig file" })
vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "(f)ind (b)uffer" })
vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "(s)earch (h)elp" })
vim.keymap.set("n", "<leader>sd", MiniPick.builtin.diagnostic, { desc = "(s)earch (d)iagnostics" })

-- Dashboard
MiniStarter = require("mini.starter")

MiniStarter.setup({
	header = [[
 /\_/\  
( o.o ) 
 > ^ <  
  ]],
	evaluate_single = true,
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
	footer = "",
	content_hooks = {
		MiniStarter.gen_hook.adding_bullet(),
		MiniStarter.gen_hook.aligning("center", "center"),
	},
})

-- LSP
require("mason").setup()

local nvim_lsp = require("lspconfig")
nvim_lsp.denols.setup({
	root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
})
nvim_lsp.vtsls.setup({
	root_dir = nvim_lsp.util.root_pattern("package.json"),
	single_file_support = false,
})

vim.lsp.inlay_hint.enable(true)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "(g)oto (d)efinition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "(g)oto (D)eclaration" })
vim.keymap.set("n", "grr", function()
	MiniExtra.pickers.lsp({
		scope = "references",
		mappings = {
			send_qf = {
				char = "<C-q>",
				function()
					require("trouble").open("lsp")
				end,
			},
		},
	})
end, { desc = "(g)oto (r)eferences" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "(g)oto (I)mplementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "(g)oto T(y)pe" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "(c)ode (a)ction" })
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "(c)ode (l)ens" })

-- Treesitter
require("nvim-treesitter.configs").setup({
	modules = {},
	ignore_install = {},
	ensure_installed = {
		"typescript",
		"python",
		"rust",
		"go",
		"zig",
		"gleam",
		"svelte",
	},
	sync_install = false,
	auto_install = true,
	highlight = { enable = true },
})
