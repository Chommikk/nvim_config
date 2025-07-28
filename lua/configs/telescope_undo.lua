return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>U", "<cmd>Telescope undo<cr>", desc = "Telescope: Undo history" },
  },
  opts = {
    use_delta = true,      -- use 'delta' if installed
    use_custom_command = nil,
  },
  config = function(_, opts)
    require("telescope").setup({ extensions = { undo = opts } })
    require("telescope").load_extension("undo")
  end,
}

