return {
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          undo = {
            use_delta = true,
            side_by_side = true,
          },
        },
      })
      telescope.load_extension("undo")

      vim.keymap.set("n", "<leader>U", "<cmd>Telescope undo<cr>", { desc = "Telescope: Undo history" })
    end,
  },
}

