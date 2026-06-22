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

require("vim._core.ui2").enable({})

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

vim.pack.add({
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  { src = "https://github.com/saghen/blink.lib", version = "2.*" },
  { src = "https://github.com/saghen/blink.cmp", version = "2.*" },
  "https://github.com/rafamadriz/friendly-snippets",
}, { confirm = false, load = true })

vim.cmd.colorscheme("nightfox")

require("mini.basics").setup()
require("mini.icons").setup()
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.bracketed").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()

require("mini.files").setup()
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "File Explorer" })

require("mini.diff").setup({ view = { style = "number" } })
vim.keymap.set("n", "<leader>go", function()
  MiniDiff.toggle_overlay(vim.api.nvim_get_current_buf())
end, { desc = "Toggle Git Overlay" })

local MiniClue = require("mini.clue")
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
    { mode = "i", keys = "<C-x>" },
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
  window = { delay = 200 },
})

require("mini.pick").setup({})
vim.ui.select = MiniPick.ui_select
MiniPick.registry.config = function(local_opts, opts)
  MiniPick.builtin.files(
    local_opts or {},
    vim.tbl_extend("force", opts or {}, { source = { name = "config", cwd = "~/dotfiles" } })
  )
end
MiniPick.registry.todos = function(local_opts, opts)
  MiniPick.builtin.grep(vim.tbl_extend("force", local_opts or {}, { pattern = "TODO|FIXME|NOTE|BUG|HACK" }), opts or {})
end

vim.keymap.set("n", "<leader>sf", "<cmd>Pick files<cr>", { desc = "Search Files" })
vim.keymap.set("n", "<leader>sr", "<cmd>Pick oldfiles<cr>", { desc = "Search Recent Files" })
vim.keymap.set("n", "<leader>sc", "<cmd>Pick config<cr>", { desc = "Search Config" })
vim.keymap.set("n", "<leader>st", "<cmd>Pick todos<cr>", { desc = "Search Todo Comments" })
vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sb", "<cmd>Pick buffers<cr>", { desc = "Search Buffers" })
vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "Search Help" })
vim.keymap.set("n", "<leader>z=", "<cmd>Pick spellsuggest<cr>", { desc = "Show spelling suggestions" })

require("mini.starter").setup({
  header = [[
  │ ╲ ││
  ││╲╲││
  ││ ╲ │]],
  footer = "NVIM v" .. tostring(vim.version()),
  items = {
    { name = "Search File  ", action = "Pick files", section = "" },
    { name = "Grep Live  ", action = "Pick grep_live", section = "" },
    { name = "New File  ", action = "ene | startinsert", section = "" },
    { name = "Recent Files  ", action = "Pick oldfiles", section = "" },
    { name = "Config  ", action = "Pick config", section = "" },
    { name = "Help 󰋖", action = "Pick help", section = "" },
    { name = "Update Plugins 󰒲 ", action = "PackUpdate", section = "" },
    { name = "Quit  ", action = "qa", section = "" },
  },
  evaluate_single = true,
})

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = "/Users/basokant/Library/pnpm/global/5/node_modules/@vue/language-server",
  languages = { "vue", "javascript", "typescript" },
}

vim.lsp.config("vtsls", {
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

vim.lsp.enable({
  "lua_ls",
  "ruff",
  "pyright",
  "denols",
  "vtsls",
  "astro",
  "emmet_language_server",
  "gopls",
  "golangci_lint_ls",
  "eslint",
  "zls",
  "tinymist",
  "marksman",
  "vue_ls",
  "svelte",
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    vue = { "prettier" },
  },
  format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

require("blink.cmp").setup({
  sources = {
    default = { "lsp", "path", "snippets" },
  },
  signature = { enabled = true },
})
