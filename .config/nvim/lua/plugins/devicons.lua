return {
  "nvim-tree/nvim-web-devicons",
  opts = {
    strict = true,
    override_by_extension = {
      ["astro"] = {
        icon = "",
        color = "#EF8547",
        name = "astro",
      },
      ["pcss"] = {
        icon = "",
        color = "#D2240D",
        name = "PostCSS",
      },
    },
    override_by_filename = {
      ["tsconfig.json"] = {
        icon = "󰛦",
        color = "#288AB0",
        name = "TSConfig",
      },
    },
  },
  lazy = true,
}
