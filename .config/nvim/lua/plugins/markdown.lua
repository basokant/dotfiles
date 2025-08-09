return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    heading = {
      sign = true,
    },
    bullet = {
      right_pad = 1,
    },
    quote = {
      repeat_linebreak = true,
    },
    win_options = {
      showbreak = {
        default = "",
        rendered = "  ",
      },
      breakindent = {
        default = false,
        rendered = true,
      },
      breakindentopt = {
        default = "",
        rendered = "",
      },
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
}
