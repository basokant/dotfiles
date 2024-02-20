return {
  "folke/zen-mode.nvim",
  opts = {
    plugins = {
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
