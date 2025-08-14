vim.opt.relativenumber = true
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

-- Set tab and indentation
vim.opt.tabstop = 2
vim.opt.showtabline = 0
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

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
    priority = 1000
  },

  -- MINI plugins that cover so much!
  {
    'echasnovski/mini.nvim',
    version = false
  },

  -- TreeSitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP
  {
    'mason-org/mason.nvim',
    opts = function()
      require("mason").setup()
    end
  },                           -- installs LSP servers
  { 'neovim/nvim-lspconfig' }, -- configures LSPs
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        "lua_ls",
        "stylua",
        "svelte",
        "gopls",
        "denols",
        "zls",
        "ts_ls",
        "astro",
        "emmet_language_server",
        "pico8_ls",
      },
      servers = {
        gleam = {}
      }
    }
  }, -- links the two above

  -- Some LSPs don't support formatting, this fills the gaps
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" }
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
    'saghen/blink.cmp',
    version = '1.*',
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
    }
  },

  {
    {
      "folke/snacks.nvim",
      ---@type snacks.Config
      opts = {
        styles = {
          lazygit = {
            border = "rounded"
          }
        },
        lazygit = {},
        dashboard = {
          preset = {
            pick = "mini.pick",
            header =
            [[
\    /\
 )  ( ')
(  /  )
 \(__)|
              ]]

          }
        }
      }
    }
  },
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
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,                      -- 0.6      [0, 1]
      trailing_stiffness = 0.5,             -- 0.4      [0, 1]
      stiffness_insert_mode = 0.7,          -- 0.5      [0, 1]
      trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
      damping = 0.8,                        -- 0.65     [0, 1]
      damping_insert_mode = 0.8,            -- 0.7      [0, 1]
      distance_stop_animating = 0.5,        -- 0.1      > 0

      smear_between_buffers = false,
      smear_insert_mode = false,
      smear_to_cmd = false,
    },
  }
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

vim.cmd.colorscheme("catppuccin")

Snacks = require("snacks")

require("mini.basics").setup({
  options = {
    extra_ui = true,
  }
})

require("mini.icons").setup()
require("mini.ai").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.jump").setup()
require("mini.notify").setup()
require("mini.bracketed").setup()
require("mini.sessions").setup()

require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.diff").setup()

MiniClue = require("mini.clue")
MiniClue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- Bracketed motions (with mini.bracketed)
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
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
    delay = 200
  }
})

MiniFiles = require("mini.files")
MiniFiles.setup()

vim.keymap.set('n', '<leader>e', MiniFiles.open, { desc = 'Open MiniFiles' })

vim.keymap.set("n", "<leader>bd", "<CMD>bd<CR>", { desc = "Close current buffer" })

MiniPick = require("mini.pick")
MiniExtra = require("mini.extra")

-- Centered on screen
local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = 'NW',
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
  require("trouble").open('quickfix')
  return true
end


MiniPick.setup({
  window = { config = win_config },
  mappings = {
    send_qf = {
      char = "<C-q>",
      func = send_to_qflist
    }
  }
})

-- Override Select with MiniPick
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = MiniPick.ui_select

-- Pickers
vim.keymap.set("n", "<leader>ff", MiniPick.builtin.files, { desc = "(f)ind (f)ile" })
vim.keymap.set("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "(f)ind (e)xplorer" })
vim.keymap.set("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "(f)ind (b)uffer" })
vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "(s)earch (h)elp" })
vim.keymap.set("n", "<leader>sd", function()
  MiniExtra.pickers.diagnostic({
    mappings = {
      send_qf = {
        char = "<C-q>",
        func = function()
          require("trouble").open("diagnostics")
        end
      }
    }
  })
end, { desc = "(s)earch (d)iagnostics" })

-- LSP
require("mason").setup()
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
        end
      }
    }
  })
end, { desc = "(g)oto (r)eferences" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "(g)oto (I)mplementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "(g)oto T(y)pe" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "(c)ode (a)ction" })
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "(c)ode (l)ens" })

vim.keymap.set('n', '<leader>gg', Snacks.lazygit.open, { desc = 'Open Lazygit' })

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
    "svelte"
  },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true, },
})
