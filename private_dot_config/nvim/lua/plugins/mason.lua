if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
  { "williamboman/mason.nvim", config = true, cmd = "Mason", dependencies = { "roslyn.nvim" }, registries = { "github:crashdummyy/mason-registry"} },
  { "williamboman/mason-lspconfig.nvim", config = true, cmd = { "LspInstall", "LspUninstall" } },
  { "seblyng/nvim-lsp-extras", opts = { global = { border = CUSTOM_BORDER } }, dev = true },
  { "onsails/lspkind.nvim" },
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    
    opts = {
      -- Make sure to use the names found in `:Mason`
        registries = {
    'github:mason-org/mason-registry',
    'github:crashdummyy/mason-registry',
  },
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}

