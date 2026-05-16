return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  cmd = { "DapContinue", "DapToggleBreakpoint", "DapInstallAdapters", "DapHealthCheck" },
  keys = {
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue/Start" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup DAP UI with a nice layout
    dapui.setup({
      icons = { expanded = "", collapsed = "", current_frame = "" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 0.25,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "", play = "", step_into = "",
          step_over = "", step_out = "", step_back = "",
          run_last = "", terminate = "",
        },
      },
    })

    -- Setup virtual text
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = "<module",
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    })

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    -- Custom signs for breakpoints
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

    -- Highlight groups for DAP
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f1c40f" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e3b2e" })
    vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#656565" })

    ----------------------------------------------------------------------------
    -- TypeScript / JavaScript Configuration
    ----------------------------------------------------------------------------
    local js_debug_path = vim.fn.stdpath("data") .. "/js-debug"
    local js_debug_adapter = js_debug_path .. "/src/dapDebugServer.js"
    local mason_js_debug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.filereadable(js_debug_adapter) == 1 and js_debug_adapter
            or mason_js_debug .. "/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }
    dap.adapters["node"] = dap.adapters["pwa-node"]

    local js_ts_config = {
      {
        type = "pwa-node", request = "launch", name = "Launch file",
        program = "${file}", cwd = "${workspaceFolder}",
        sourceMaps = true, skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
      {
        type = "pwa-node", request = "launch", name = "Launch file (ts-node)",
        program = "${file}", cwd = "${workspaceFolder}",
        runtimeExecutable = "ts-node", sourceMaps = true,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
      {
        type = "pwa-node", request = "attach", name = "Attach to process",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}", sourceMaps = true,
      },
      {
        type = "pwa-node", request = "launch", name = "Debug Jest tests",
        runtimeExecutable = "node",
        runtimeArgs = { "./node_modules/jest/bin/jest.js", "--runInBand" },
        rootPath = "${workspaceFolder}", cwd = "${workspaceFolder}",
        console = "integratedTerminal", internalConsoleOptions = "neverOpen", sourceMaps = true,
      },
      {
        type = "pwa-node", request = "launch", name = "Debug Vitest tests",
        runtimeExecutable = "node",
        runtimeArgs = { "./node_modules/vitest/vitest.mjs", "run", "${file}" },
        rootPath = "${workspaceFolder}", cwd = "${workspaceFolder}",
        console = "integratedTerminal", sourceMaps = true,
      },
    }

    dap.configurations.javascript = js_ts_config
    dap.configurations.typescript = js_ts_config
    dap.configurations.typescriptreact = js_ts_config
    dap.configurations.javascriptreact = js_ts_config

    ----------------------------------------------------------------------------
    -- Rust Configuration (via codelldb)
    ----------------------------------------------------------------------------
    local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
    if vim.fn.executable(codelldb_path) ~= 1 then
      codelldb_path = "codelldb"
    end

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = codelldb_path, args = { "--port", "${port}" } },
    }

    dap.adapters.lldb = {
      type = "executable",
      command = "/usr/bin/lldb-dap",
      name = "lldb",
    }

    local function get_rust_binary()
      local handle = io.popen("cargo metadata --format-version 1 --no-deps 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        local ok, metadata = pcall(vim.json.decode, result)
        if ok and metadata and metadata.packages and metadata.packages[1] then
          local pkg = metadata.packages[1]
          local target_dir = metadata.target_directory or (pkg.manifest_path:gsub("/Cargo.toml$", "") .. "/target")
          for _, target in ipairs(pkg.targets or {}) do
            if vim.tbl_contains(target.kind, "bin") then
              return target_dir .. "/debug/" .. target.name
            end
          end
        end
      end
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end

    dap.configurations.rust = {
      {
        name = "Launch (codelldb)", type = "codelldb", request = "launch",
        program = function() vim.fn.system("cargo build"); return get_rust_binary() end,
        cwd = "${workspaceFolder}", stopOnEntry = false, args = {}, runInTerminal = false,
      },
      {
        name = "Launch with args (codelldb)", type = "codelldb", request = "launch",
        program = function() vim.fn.system("cargo build"); return get_rust_binary() end,
        cwd = "${workspaceFolder}", stopOnEntry = false,
        args = function() return vim.split(vim.fn.input("Arguments: "), " ") end,
        runInTerminal = false,
      },
      {
        name = "Attach to process (codelldb)", type = "codelldb", request = "attach",
        pid = require("dap.utils").pick_process, cwd = "${workspaceFolder}",
      },
      {
        name = "Debug test (codelldb)", type = "codelldb", request = "launch",
        program = function()
          vim.fn.system("cargo test --no-run")
          local handle = io.popen("cargo test --no-run --message-format=json 2>&1 | grep -o '\"executable\":\"[^\"]*\"' | head -1 | cut -d'\"' -f4")
          if handle then
            local result = handle:read("*l")
            handle:close()
            if result and result ~= "" then return result end
          end
          return vim.fn.input("Path to test executable: ", vim.fn.getcwd() .. "/target/debug/deps/", "file")
        end,
        cwd = "${workspaceFolder}", stopOnEntry = false,
        args = function()
          local test_name = vim.fn.input("Test name (empty for all): ")
          if test_name == "" then return {} end
          return { test_name, "--exact", "--nocapture" }
        end,
      },
    }

    dap.configurations.c = dap.configurations.rust
    dap.configurations.cpp = dap.configurations.rust

    ----------------------------------------------------------------------------
    -- Keybindings (set after loading, overrides the lazy keys triggers)
    ----------------------------------------------------------------------------
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Conditional breakpoint" })
    vim.keymap.set("n", "<leader>dl", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, { desc = "Log point" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue/Start" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<leader>dR", dap.run_last, { desc = "Run last" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
    vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Evaluate expression" })
    vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Evaluate selection" })
    vim.keymap.set("n", "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Hover variables" })
    vim.keymap.set("n", "<leader>dp", function() require("dap.ui.widgets").preview() end, { desc = "Preview" })
    vim.keymap.set("n", "<leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end, { desc = "Show frames" })
    vim.keymap.set("n", "<leader>ds", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end, { desc = "Show scopes" })

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

    -- Register debug keybindings with which-key (if loaded)
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>d", group = "Debug" },
        { "<leader>db", desc = "Toggle breakpoint" },
        { "<leader>dB", desc = "Conditional breakpoint" },
        { "<leader>dl", desc = "Log point" },
        { "<leader>dc", desc = "Continue/Start" },
        { "<leader>di", desc = "Step into" },
        { "<leader>do", desc = "Step over" },
        { "<leader>dO", desc = "Step out" },
        { "<leader>dr", desc = "Toggle REPL" },
        { "<leader>dR", desc = "Run last" },
        { "<leader>dt", desc = "Terminate" },
        { "<leader>du", desc = "Toggle UI" },
        { "<leader>de", desc = "Evaluate" },
        { "<leader>dh", desc = "Hover variables" },
        { "<leader>dp", desc = "Preview" },
        { "<leader>df", desc = "Show frames" },
        { "<leader>ds", desc = "Show scopes" },
      })
    end

    ----------------------------------------------------------------------------
    -- Installation helper commands
    ----------------------------------------------------------------------------
    vim.api.nvim_create_user_command("DapInstallAdapters", function()
      local instructions = [[
Debug Adapter Installation Guide:

TypeScript/JavaScript (js-debug-adapter):
  Option 1: Install via Mason
    :MasonInstall js-debug-adapter

  Option 2: Manual install
    cd ~/.local/share/nvim
    git clone https://github.com/microsoft/vscode-js-debug js-debug
    cd js-debug
    npm install && npm run compile

Rust (codelldb):
  Option 1: Install via Mason
    :MasonInstall codelldb

  Option 2: Manual install
    Download from: https://github.com/vadimcn/codelldb/releases
    Extract to ~/.local/share/nvim/codelldb

  Option 3: System package manager
    # Arch Linux
    yay -S codelldb

    # Or use lldb-dap (included with LLVM)
    sudo apt install lldb  # Debian/Ubuntu
]]
      vim.notify(instructions, vim.log.levels.INFO)
    end, { desc = "Show debug adapter installation instructions" })

    vim.api.nvim_create_user_command("DapHealthCheck", function()
      local checks = {}

      local js_debug_locations = {
        vim.fn.stdpath("data") .. "/js-debug/src/dapDebugServer.js",
        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      }
      local js_debug_found = false
      for _, path in ipairs(js_debug_locations) do
        if vim.fn.filereadable(path) == 1 then
          js_debug_found = true
          table.insert(checks, "TypeScript/JS (js-debug): OK - " .. path)
          break
        end
      end
      if not js_debug_found then
        table.insert(checks, "TypeScript/JS (js-debug): NOT FOUND - Run :DapInstallAdapters for instructions")
      end

      local codelldb_locations_check = {
        vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        "/usr/bin/codelldb",
        vim.fn.exepath("codelldb"),
      }
      local codelldb_found = false
      for _, path in ipairs(codelldb_locations_check) do
        if path ~= "" and vim.fn.executable(path) == 1 then
          codelldb_found = true
          table.insert(checks, "Rust (codelldb): OK - " .. path)
          break
        end
      end
      if not codelldb_found then
        if vim.fn.executable("lldb-dap") == 1 then
          table.insert(checks, "Rust (lldb-dap): OK - lldb-dap found as alternative")
        elseif vim.fn.executable("lldb-vscode") == 1 then
          table.insert(checks, "Rust (lldb-vscode): OK - lldb-vscode found as alternative")
        else
          table.insert(checks, "Rust (codelldb): NOT FOUND - Run :DapInstallAdapters for instructions")
        end
      end

      vim.notify(table.concat(checks, "\n"), vim.log.levels.INFO)
    end, { desc = "Check debug adapter installation status" })
  end,
}
