-- return {
-- 	{
-- 		"sakhnik/nvim-gdb",
-- 		config = function()
-- 			vim.keymap.set("n", "<leader>dr", ":GdbRun<CR>", { desc = "[D]ebug [R]un" })
-- 		end,
-- 	},
--
-- }
return {
  { 
    'mfussenegger/nvim-dap',
    dependencies = {
      'Joakker/lua-json5',
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'jbyuki/one-small-step-for-vimkind',
    },
    keys = {
      -- Basic debugging keymaps, feel free to change to your liking!
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F11>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<F10>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F12>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<F8>',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<F9>',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See dap ui',
      },
      {
        '<F6>',
        function()
          require('dap').run_last()
        end,
        desc = 'Debug: Run Last',
      },
      {
        '<F4>',
        function()
          require('dap').terminate()
        end,
        desc = 'Debug: Terminate',
      }
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'codelldb',
        },
      }

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        },
        {
          type = 'nlua',
          request = 'launch',
          name = 'Launch Neovim',
          -- Note the change from 'program' and 'args' to a single 'program' table
          -- This is a cleaner way to handle commands with arguments in nvim-dap
          program = {
            command = 'nvim',
            args = {
              '--clean', -- Recommended: start with a clean config to avoid side-effects
              '-c',
              "lua require('osv').launch({port = 8086})",
            },
          },
          cwd = '${workspaceFolder}',
          sourceMaps = true,
        },
      }

      local gdb_major_version = tonumber(vim.fn.system('gdb --version | head -n 1 | grep -oP "\\d+" | head -n 1'))
      if gdb_major_version and gdb_major_version >= 14 then
        dap.adapters.gdb = {
            id = 'gdb',
            type = 'executable',
            command = 'gdb',
            args = { '--quiet', '--interpreter=dap' },
        }
        dap.configurations.cpp = {
          {
              name = 'Run executable (GDB)',
              type = 'gdb',
              request = 'launch',
              -- This requires special handling of 'run_last', see
              -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
              program = function()
                  local path = vim.fn.input({
                      prompt = 'Path to executable: ',
                      default = vim.fn.getcwd() .. '/',
                      completion = 'file',
                  })

                  return (path and path ~= '') and path or dap.ABORT
              end,
          },
          {
              name = 'Run executable with arguments (GDB)',
              type = 'gdb',
              request = 'launch',
              -- This requires special handling of 'run_last', see
              -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
              program = function()
                  local path = vim.fn.input({
                      prompt = 'Path to executable: ',
                      default = vim.fn.getcwd() .. '/',
                      completion = 'file',
                  })

                  return (path and path ~= '') and path or dap.ABORT
              end,
              args = function()
                  local args_str = vim.fn.input({
                      prompt = 'Arguments: ',
                  })
                  return vim.split(args_str, ' +')
              end,
          },
        }
      else
        vim.notify("GCC version is too low for GDB support. Please update GCC to version 14 or higher.", vim.log.levels.WARN)
      end

      local vscode_debugger_path = vim.fn.system('just --evaluate -f ${DOTFILES_DIR}/deps/justfile vscode_dbg_path')
      vim.notify("Using VSCode debugger path: " .. vscode_debugger_path)
      -- Check if file exists
      if vim.fn.filereadable(vscode_debugger_path) == 1 then
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = vscode_debugger_path,
        }
      end

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

    
      -- Check existence of debugpy
      local debugpy = nil
      local pip3 = require("pl.stringx").strip(vim.fn.system('which pip3'))
      if pip3 == '' then
        vim.notify("pip3 not found in PATH. Please install pip3.", vim.log.levels.ERROR)
        return
      else
        debugpy = vim.fn.system('pip3 show debugpy')
      end

      if debugpy then
        dap.adapters.python = {
          type = 'executable',
          command = 'python3',
          args = { '-m', 'debugpy.adapter' },
        }
      else 
        vim.notify("debugpy not found. Please install debugpy with 'pip3 install debugpy'", vim.log.levels.WARN)
      end
    end,
  },
  { 'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        all_references = true,
        virt_text_pos = 'eol',
        show_stop_reason = true,
        commented = false,
      }
    end,
  },
  { 'GeorgiiKrikun/dbg_interface.nvim',
    -- dir = '~/software/dbg_interface.nvim',
    dependencies = { 'lunarmodules/penlight' },
    opts = {
      rust = {
        config = {
          name = "",
          type = "codelldb",
          request = "launch",
          program = "",
          stopAtEntry = false,
          cwd = "${workspaceFolder}",
          environment = {
            RUST_BACKTRACE = "1"
          },
          externalConsole = false,
          justMyCode = true,
          args="",
          setupCommands = {
            {
               text = '-enable-pretty-printing',
               description =  'enable pretty printing',
               ignoreFailures = false
            },
          },
        },
        opts = {
          filetype = "rust",
        },
      },
      cpp = {
        config = {
          name = "Cppdbg with vscode",
          type = "cppdbg",
          request = "launch",
          program = "",
          stopAtEntry = false,
          cwd = "${workspaceFolder}",
          environment = {},
          externalConsole = false,
          justMyCode = true,
          args="",
          setupCommands = {  
            { 
               text = '-enable-pretty-printing',
               description =  'enable pretty printing',
               ignoreFailures = false 
            },
          },
        },
        opts = {
          filetype = "cpp",
        },
      },
      python = {
        config = {
          name = "Python with pydebug",
          type = "python",
          request = "launch",
          program = "",
          pythonPath = function()
            local venv_var = os.getenv('VIRTUAL_ENV')
            if venv_var then
              return venv_var .. '/bin/python'
            else
              return '/usr/bin/python3'
            end
          end;
          stopAtEntry = false,
          cwd = "${workspaceFolder}",
        },
        opts = {
          filetype = "python",
        },
      },
    },
    config = function(_, opts)
      require("dbg_interface").setup(opts)
      vim.keymap.set("n", "<leader>dnr", function() require("dbg_interface").dbg_args_async('rust') end, { desc = "[D]ebug [N]ew Rust configuration" })
      vim.keymap.set("n", "<leader>dar", function() require("dbg_interface").run_existing_dbg_cfg('rust') end, { desc = "[D]ebug with [A]lready used rust configuration" })
      vim.keymap.set("n", "<leader>ddr", function() require("dbg_interface").delete_existing_dbg_cfg('rust') end, { desc = "[D]elete [A]lready used rust configuration" })

      vim.keymap.set("n", "<leader>dnc", function() require("dbg_interface").dbg_args_async('cpp') end, { desc = "[D]ebug [N]ew Cpp configuration" })
      vim.keymap.set("n", "<leader>dac", function() require("dbg_interface").run_existing_dbg_cfg('cpp') end, { desc = "[D]ebug with [A]lready used cpp configuration" })
      vim.keymap.set("n", "<leader>ddc", function() require("dbg_interface").delete_existing_dbg_cfg('cpp') end, { desc = "[D]elete [A]lready used cpp configuration" })

      vim.keymap.set("n", "<leader>dnp", function() require("dbg_interface").dbg_args_async('python') end, { desc = "[D]ebug [N]ew Python configuration" })
      vim.keymap.set("n", "<leader>dap", function() require("dbg_interface").run_existing_dbg_cfg('python') end, { desc = "[D]ebug with [A]lready used python configuration" })
      vim.keymap.set("n", "<leader>ddp", function() require("dbg_interface").delete_existing_dbg_cfg('python') end, { desc = "[D]elete [A]lready used python configuration" })
    end,
  }
}
