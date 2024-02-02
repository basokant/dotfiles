return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- stylua: ignore start
      map("n", "<leader>ghb", ":Gitsigns toggle_current_line_blame<CR>", "Blame Line")
      map("n", "<leader>ghB", function() gs.blame_line({ full = true }) end, "Blame Line detailed")
    end,
  },
}
