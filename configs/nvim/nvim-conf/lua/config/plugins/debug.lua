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

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      local vscode_ext = require('dap.ext.vscode')
      vscode_ext.json_decode = require("json5").parse
      -- Load VSCode debug configurations
      vscode_ext.load_launchjs(nil, { codelldb = { 'cpp', 'c', 'rust' } })

      -- Load dap-native configurations
      local cwd = vim.fn.getcwd()
      local dap_lua = cwd .. "/.nvim/dap_config.lua"
      if vim.fn.filereadable(dap_lua) == 1 then
        vim.notify("Loading custom dap configurations from: " .. dap_lua, vim.log.levels.INFO)
        dofile(dap_lua)
      end

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

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
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
}
