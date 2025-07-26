require("nvchad.configs.lspconfig").defaults()


-- In your nvim config (init.lua or wherever you configure LSP)
local function get_clangd_cmd()
  -- Check if we're on NixOS
  if vim.fn.filereadable('/etc/NIXOS') == 1 then
    -- Try common Nix paths
    local nix_paths = {
      '/run/current-system/sw/bin/clangd',
      vim.fn.expand('~/.nix-profile/bin/clangd'),
      '/nix/store/*/bin/clangd'  -- This might need adjustment
    }
    
    for _, path in ipairs(nix_paths) do
      if vim.fn.executable(path) == 1 then
        return { path }
      end
    end
  end
  
  -- Fallback to system PATH (Ubuntu, etc.)
  if vim.fn.executable('clangd') == 1 then
    return { 'clangd' }
  end
  
  -- If nothing found, return nil and let LSP handle the error
  return nil
end

-- Configure clangd
local lspconfig = require('lspconfig')
local clangd_cmd = get_clangd_cmd()

if clangd_cmd then
  lspconfig.clangd.setup({
    cmd = clangd_cmd,
    -- your other clangd config
  })
end
local servers = { "html", "cssls", "clangd" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
