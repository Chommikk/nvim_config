return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",  -- lazy-load only when toggled
    config = function()
      -- optional: custom config
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
    end,
  },
}

