return {
  {
    "zbirenbaum/copilot.vim",
    lazy = false,
    cond = function ()
      return vim.g.active_profile == vim.g.profiles.home
    end
  },
  -- NOTE: Copilot char neovim
  -- {
  -- 	"CopilotC-Nvim/CopilotChat.nvim",
  -- 	dependencies = {
  -- 		{ "zbirenbaum/copilot.vim" }, -- or zbirenbaum/copilot.lua
  -- 		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  -- 	},
  -- 	build = "make tiktoken", -- Only on MacOS or Linux
  -- 	opts = {
  -- 		-- model = "gemini-2.5-flash",
  -- 		-- See Configuration section for options
  -- 		mappings = {
  -- 			reset = {
  -- 				normal = "<C-r>",
  -- 				insert = "<C-r>",
  -- 			},
  -- 		},
  -- 	},
  -- 	-- See Commands section for default commands if you want to lazy load on them
  { 
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    cond = function ()
      return vim.g.active_profile == vim.g.profiles.home
    end,
    build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- this file can contain specific instructions for your project
      instructions_file = "avante.md",
      -- for example
      provider = "copilot/gpt-4o",
      providers = {
        copilot = {
          suggestion_provider = "copilot.vim", -- or nil, depending on your copilot setup
        },
        ["copilot/claude-3.5"] = {
          __inherited_from = "copilot",
          model = "claude-3.5-sonnet", -- Example model
          display_name = "Copilot (Claude 3.5)",
        },
        ["copilot/gpt-4o"] = {
          __inherited_from = "copilot",
          model = "gpt-4o", -- Example model
          display_name = "Copilot (GPT-4o)",
        },
        ["copilot/gemini-2.5"] = {
          __inherited_from = "copilot",
          model = "gemini-2.5-pro", -- Example model
          display_name = "Copilot (Gemini 2.5 Pro)",
        },
        gemini = {
          -- Replace with your company's internal Gemini API endpoint if different.
          endpoint = "https://api.google.com/v1", 
          -- Use the model name your company provides (e.g., gemini-2.5-pro, gemini-2.5-flash)
          model = "gemini-2.5-pro", 
          api_key_name = "GEMINI_API_KEY", -- Environment variable name for the API key
          timeout = 60000, -- Longer timeout might be useful for enterprise proxies/VPNs
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 4096,
            -- You might need other fields for an enterprise setup, like 
            -- `generationConfig` or custom headers, which you can add here.
            -- generationConfig = {
            --   stopSequences = {"test"},
            -- },
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
