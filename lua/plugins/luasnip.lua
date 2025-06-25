return {
  "L3MON4D3/LuaSnip",
  lazy = false,
  priority = 1000,
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    })

    require("luasnip.loaders.from_vscode").lazy_load()

    local opts_expr = { silent = true, noremap = true, expr = true }
    local opts_func = { silent = true, noremap = true, expr = false }

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Override <Tab> and <CR> to insert literal tab/enter (disable snippet expansion/jump)
        vim.keymap.set({ "i", "s" }, "<Tab>", function()
          return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
        end, opts_expr)

        vim.keymap.set({ "i", "s" }, "<CR>", function()
          return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
        end, opts_expr)

        -- Custom snippet navigation mappings
        vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end, opts_func)

        vim.keymap.set({ "i", "s" }, "<S-CR>", function()
          if ls.choice_active() then
            ls.change_choice(1)
          elseif ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end, opts_func)
      end,
    })
  end,
}

