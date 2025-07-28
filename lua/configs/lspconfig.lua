-- Load base nvchad LSP config
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- Add Python LSP
local function get_pylsp_cmd()
  if vim.fn.filereadable("/etc/NIXOS") == 1 then
    local paths = {
      "/run/current-system/sw/bin/pylsp",
      vim.fn.expand("~/.nix-profile/bin/pylsp"),
    }
    for _, path in ipairs(paths) do
      if vim.fn.executable(path) == 1 then
        return { path }
      end
    end
  end
  if vim.fn.executable("pylsp") == 1 then
    return { "pylsp" }
  end
  return nil
end

local pylsp_cmd = get_pylsp_cmd()

if pylsp_cmd then
  lspconfig.pylsp.setup({
    cmd = pylsp_cmd,
    settings = {
      pylsp = {
        plugins = {
          pyflakes = { enabled = true },
          pycodestyle = { enabled = true },
          pylint = { enabled = false }, -- optional
        },
      },
    },
  })
end

-- clangd config (already in your config)
local function get_clangd_cmd()
  if vim.fn.filereadable('/etc/NIXOS') == 1 then
    local nix_paths = {
      '/run/current-system/sw/bin/clangd',
      vim.fn.expand('~/.nix-profile/bin/clangd'),
    }
    for _, path in ipairs(nix_paths) do
      if vim.fn.executable(path) == 1 then
        return { path }
      end
    end
  end
  if vim.fn.executable('clangd') == 1 then
    return { 'clangd' }
  end
  return nil
end

local clangd_cmd = get_clangd_cmd()

if clangd_cmd then
  lspconfig.clangd.setup({
    cmd = clangd_cmd,
  })
end

-- Add other servers (these are auto-loaded if installed)
local servers = { "html", "cssls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({})
end

