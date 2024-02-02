vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

vim.treesitter.language.register("markdown", "mdx")

-- add more treesitter parsers
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "go",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "svelte",
      "astro",
      "kdl",
      "ocaml",
    },
  },
}
