return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint" },
        quarto = { "markdownlint" },
        ["markdown.quarto"] = { "markdownlint" },
      },
      linters = {
        markdownlint = {
          command = "markdownlint",
          args = { "--fix", "--disable", "MD013", "MD001", "--" },
        },
      },
    },
  },
}
