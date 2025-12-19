-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
return {
  "neovim/nvim-lspconfig",
  config = function()
    local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local blink_ok, blink_cmp = pcall(require, "blink.cmp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_ok and cmp_nvim_lsp.default_capabilities() or blink_ok and blink_cmp.get_lsp_capabilities() or {}
    )
    require("mason-lspconfig").setup_handlers({
      function(server)
        local config = vim.tbl_deep_extend("error", {
          capabilities = capabilities,
        }, require("config.lspconfig.settings")[server] or {})

        -- Something weird with rust-analyzer and nvim-cmp capabilites
        -- Makes the completion experience awful
        if server == "rust_analyzer" and cmp_ok then
          config.capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
            resolveSupport = {
              properties = {
                "additionalTextEdits",
                "textEdits",
                "tooltip",
                "location",
                "command",
              },
            },
          })
        end

        require("lspconfig")[server].setup(config)
      end,
    })
  end,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "${3rd}/busted/library" },
          { path = "${3rd}/luassert/library" },
          { path = "snacks.nvim", words = { "Snacks" } },
          { path = "nvim-test" },
        },
      },
    },
    { "b0o/schemastore.nvim" },
    {
      "williamboman/mason.nvim",
      config = true,
      cmd = "Mason",
      dependencies = { "roslyn.nvim" },
      registries = { "github:Crashdummyy/mason-registry" },
    },
    { "williamboman/mason-lspconfig.nvim", config = true, cmd = { "LspInstall", "LspUninstall" } },
    { "seblyng/nvim-lsp-extras", opts = { global = { border = CUSTOM_BORDER } }, dev = true },
    { "onsails/lspkind.nvim" },
  },
  {
    "mfussenegger/nvim-dap",
    keys = { "<leader>d<leader>", "<leader>db" },
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      ---@diagnostic disable-next-line: missing-fields
      dapui.setup({
        mappings = {
          edit = "i",
          remove = "dd",
        },
      })({
        "seblyng/roslyn.nvim",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
          -- your configuration comes here; leave empty for default settings
        },
      })

      local function keymap(mode, lhs, rhs, opts)
        opts.desc = string.format("Dap: %s", opts.desc)
        vim.keymap.set(mode, lhs, function()
          rhs()
          vim.fn["repeat#set"](vim.keycode(lhs))
        end, opts)
      end

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

      keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Add breakpoint" })
      keymap("n", "<leader>d<leader>", dap.continue, { desc = "Continue debugging" })
      keymap("n", "<leader>dl", dap.step_into, { desc = "Step into" })
      keymap("n", "<leader>dj", dap.step_over, { desc = "Step over" })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Per language config
      require("config.dap.cs").setup()
      require("config.dap.rust").setup()
    end,
  },
}
