return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("easy-dotnet").setup()
    end,
  },
}
