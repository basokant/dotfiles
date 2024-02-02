-- add any tools you want to have installed below
return {
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        tsserver = {
          settings = {
            typescript = {},
          },
        },
        ocamllsp = {},
      },
    },
  },
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
      },
    },
  },
}
