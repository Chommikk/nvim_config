return {
  {
    "Diogo-ss/42-header.nvim",
    event = "VeryLazy", -- Load after UI is ready
    opts = {
      default_map = true,
      auto_update = true,
      user = "mchoma",
      mail = "mchoma@student.42vienna.com",
    },
    config = function(_, opts)
      require("42header").setup(opts)
    end,
  },
}
