local nvim_lsp = require("lspconfig")

-- add any tools you want to have installed below
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "svelte-language-server",
        "astro-language-server",
        "emmet-language-server",
        "graphql-language-service-cli",
        "pico8-ls",
        "omnisharp",
        "deno",
      },
    },
  },
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@class PluginLspOpts
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
          root_dir = nvim_lsp.util.root_pattern("package.json"),
        },
        ocamllsp = {},
        gleam = {},
        pico8_ls = {},
        denols = {
          filetypes = { "typescript", "typescriptreact" },
          root_dir = function(...)
            return nvim_lsp.util.root_pattern("deno.jsonc", "deno.json")(...)
          end,
        },
      },
      autoformat = false,
    },
  },
}
