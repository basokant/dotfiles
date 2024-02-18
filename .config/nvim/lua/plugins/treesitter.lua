vim.filetype.add({
  extension = {
    mdx = "mdx",
    pcss = "css",
  },
})

vim.treesitter.language.register("markdown", "mdx")
vim.treesitter.language.register("css", "pcss")

-- add more treesitter parsers
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "css",
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
