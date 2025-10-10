-- Minimal root_dir detector (expandable)
local function get_root_dir()
  return vim.fs.dirname(vim.fs.find({ ".git", "package.json", "pyproject.toml", "Cargo.toml" }, { upward = true })[1])
end

-- Check for executables across common Nix paths
local function find_executable(possible_names)
  for _, name in ipairs(possible_names) do
    if vim.fn.executable(name) == 1 then
      return name
    end
  end
  return nil
end

-- Optional: integrate with nvim-cmp if installed
local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
local capabilities = has_cmp and cmp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- Optional: define `on_attach` to set up keymaps
local function on_attach(client, bufnr)
  -- Basic keymap example
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  map("n", "gd", vim.lsp.buf.definition)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "<leader>rn", vim.lsp.buf.rename)
end

-- Define your servers here
local servers = {
  pylsp = {
    filetypes = { "python" },
    cmd = find_executable({
      "/run/current-system/sw/bin/pylsp",
      vim.fn.expand("~/.nix-profile/bin/pylsp"),
      "pylsp",
    }),
    settings = {
      pylsp = {
        plugins = {
          pyflakes = { enabled = true },
          pycodestyle = { enabled = true },
          pylint = { enabled = false },
        },
      },
    },
  },

  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp" },
    cmd = find_executable({
      "/run/current-system/sw/bin/clangd",
      vim.fn.expand("~/.nix-profile/bin/clangd"),
      "clangd",
    }),
  },


  lua_ls = {
    filetypes = { "lua" },
    cmd = find_executable({ "lua-language-server" }),
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
}

-- Setup autocommands per server
for name, server in pairs(servers) do
  if server.cmd then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = server.filetypes,
      callback = function()
        vim.lsp.start({
          name = name,
          cmd = { server.cmd },
          root_dir = get_root_dir(),
          settings = server.settings,
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end,
    })
  else
    vim.schedule(function()
      vim.notify(("LSP server `%s` not found in $PATH or Nix profile"):format(name), vim.log.levels.WARN)
    end)
  end
-- Diagnostic display configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",   -- symbol before message (e.g., "●", "■", "▎")
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

end




-- -- Load base nvchad LSP config
--
-- require("nvchad.configs.lspconfig").defaults()
--
-- local lspconfig = require("lspconfig")
--
-- -- Add Python LSP
-- local function get_pylsp_cmd()
--   if vim.fn.filereadable("/etc/NIXOS") == 1 then
--     local paths = {
--       "/run/current-system/sw/bin/pylsp",
--       vim.fn.expand("~/.nix-profile/bin/pylsp"),
--     }
--     for _, path in ipairs(paths) do
--       if vim.fn.executable(path) == 1 then
--         return { path }
--       end
--     end
--   end
--   if vim.fn.executable("pylsp") == 1 then
--     return { "pylsp" }
--   end
--   return nil
-- end
--
-- local pylsp_cmd = get_pylsp_cmd()
--
-- if pylsp_cmd then
--   lspconfig.pylsp.setup({
--     cmd = pylsp_cmd,
--     settings = {
--       pylsp = {
--         plugins = {
--           pyflakes = { enabled = true },
--           pycodestyle = { enabled = true },
--           pylint = { enabled = false }, -- optional
--         },
--       },
--     },
--   })
-- end
--
-- -- clangd config (already in your config)
-- local function get_clangd_cmd()
--   if vim.fn.filereadable('/etc/NIXOS') == 1 then
--     local nix_paths = {
--       '/run/current-system/sw/bin/clangd',
--       vim.fn.expand('~/.nix-profile/bin/clangd'),
--     }
--     for _, path in ipairs(nix_paths) do
--       if vim.fn.executable(path) == 1 then
--         return { path }
--       end
--     end
--   end
--   if vim.fn.executable('clangd') == 1 then
--     return { 'clangd' }
--   end
--   return nil
-- end
--
-- local clangd_cmd = get_clangd_cmd()
--
-- if clangd_cmd then
--   lspconfig.clangd.setup({
--     cmd = clangd_cmd,
--   })
-- end
--
-- -- Add other servers (these are auto-loaded if installed)
--
-- local servers = { "html", "cssls" }
--
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup({})
-- end

