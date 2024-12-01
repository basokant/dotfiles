return {
  "folke/zen-mode.nvim",
  opts = {
    plugins = {
      gitsigns = { enabled = true }, -- disables git signs
      wezterm = {
        enabled = true,
        font = "15", -- font size
      },
    },
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", "Toggle Zen Mode" },
  },
}
