return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        PATH = "append",
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "jsonls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"
      local os_info = vim.loop.os_uname()

      local function find_lsp_executable(server_name, additional_args)
        local is_windows = os_info.sysname:lower():find("windows") ~= nil

        -- Search for executables ending in .cmd (Windows) or matching server_name
        for _, filename in ipairs(vim.fn.readdir(mason_bin_path)) do
          local is_cmd = filename:match("%.cmd$") ~= nil
          if is_windows and is_cmd and filename:find(server_name) then
            local executable = mason_bin_path .. filename

            -- Construct the command
            local cmd_parts = { executable }

            if additional_args and type(additional_args) == "table" then
              vim.list_extend(cmd_parts, additional_args)
            end

            return cmd_parts
          elseif not is_windows and filename:find(server_name) then
            local executable = mason_bin_path .. filename

            -- Construct the command
            local cmd_parts = { executable }

            if additional_args and type(additional_args) == "table" then
              vim.list_extend(cmd_parts, additional_args)
            end

            return cmd_parts
          end
        end

        return nil
      end

      local function setup_lsp(server_name, extra_config)
        local default_config = {
          capabilities = capabilities,
        }

        local config = vim.tbl_deep_extend("force", default_config, extra_config or {})

        if not config.cmd then
          local cmd_config = find_lsp_executable(server_name, config.cmd_args)
          if cmd_config then
            config.cmd = cmd_config
          end
        end

        lspconfig[server_name].setup(config)
      end

      setup_lsp("lua_ls")
      setup_lsp("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
            extraArgs = {
              "--",
              "--no-deps",
              "-Dclippy::correctness",
              "-Dclippy::complexity",
              "-Wclippy::perf",
              "-Wclippy::pedantic",
              "-Wclippy::all",
              "-Wclippy::cargo",
              "-Wclippy::nursery",
              "-Wclippy::style",
              "-Wclippy::suspicious",
            },
            procMacro = {
              enable = true,
            },
            diagnostics = {
              styleLints = { enable = true },
            },
          },
        },
      })

      setup_lsp("clangd")
      setup_lsp("tailwindcss")
      setup_lsp("emmet_language_server")
      setup_lsp("jsonls")
      setup_lsp("taplo", {
        cmd_args = { "lsp", "stdio" },
      })

      -- Keybinds
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set({ "n" }, "<leader>gf", vim.lsp.buf.format, {})
      vim.keymap.set("n", "<leader>gr", function()
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
        })
        require("telescope.builtin").lsp_references()
      end, {})
    end,
  },
}

