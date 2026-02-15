return {
	{
		"brianhuster/unnest.nvim"
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},
	{
		"skywind3000/asyncrun.vim",
	},
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},
	{ --TODO:Move to lsp
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
					  'rafamadriz/friendly-snippets',
					  config = function()
					    require('luasnip.loaders.from_vscode').lazy_load()
					  end,
					},
				}, 
				opts = {},
			},

			"folke/lazydev.nvim",
			'Kaiser-Yang/blink-cmp-avante',
		},
		opts = {
			keymap = {
				-- set to 'none' to disable the 'default' preset
				preset = "default",

				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				-- ["<Tab>"] = { "select_next", "fallback" },
				-- ["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-space>"] = { 
					function(cmp)
						cmp.show({ providers = { "snippets", "avante" } })
					end,
				},

				-- control whether the next command will be run when using a function
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "avante", "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					avante = {
						module = 'blink-cmp-avante',
						name = 'Avante',
						opts = {
							-- options for blink-cmp-avante
						}
					}
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	{
		"andymass/vim-matchup",
	},
	{ -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
		branch = "master",
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter-textobjects",
    -- },
		lazy = false,
		config = function()
			require('nvim-treesitter.configs').setup({
				-- Add languages you want here
				ensure_installed = { "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp", "just", "cmake", "yaml", "toml", "json5", "rust" 	},
				-- Autoinstall languages that are not installed
				auto_install = true,
				sync_install = true,

				highlight = {
					enable = true, -- THIS is what was missing
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set to `false` (default) if you want tree-sitter to manage highlighting entirely.
					additional_vim_regex_highlighting = false,
				},
				
				indent = { enable = true }, -- Recommended: better indentation
			})
		end,
  },
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	build = ":TSUpdate",
	-- 	lazy = false,
	-- 	config = function()
	-- 		local ts = require("nvim-treesitter")
	--
	-- 		-- 1. Install your specific list of languages
	-- 		ts.install({
	-- 			"lua", "python", "cpp", "rust", 
	-- 			"markdown", "markdown_inline", 
	-- 			"cmake", "just", "yaml", "toml",
	-- 			"vim", "vimdoc", "query" -- Core essentials
	-- 		})
	--
	-- 		-- 2. Enable Highlighting (Native Way)
	-- 		-- This replaces the old 'highlight = { enable = true }' block
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			callback = function()
	-- 				-- Only start for the languages we just installed
	-- 				local enabled_langs = {
	-- 					"lua", "python", "cpp", "rust", "markdown", 
	-- 					"cmake", "just", "yaml", "toml"
	-- 				}
	-- 				if vim.tbl_contains(enabled_langs, vim.bo.filetype) then
	-- 					vim.treesitter.start()
	-- 				end
	-- 			end,
	-- 		})
	--
	-- 		-- 3. Enable Indentation (Experimental in main)
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			callback = function()
	-- 				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	{ -- Collection of various small independent plugins/modules
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.move").setup()
			require("mini.pairs").setup({
				mappings = {
					['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^"\\].', register = { cr = false } },
					["'"] = { action = 'closeopen', pair = "''", neigh_pattern = "[^'%a\\].", register = { cr = false } },
					['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^`\\].', register = { cr = false } },
				}}
			)
			require("mini.splitjoin").setup()
			require("mini.statusline").setup()
		end,
	},
	{ -- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {},
	},
	{
		'Joakker/lua-json5', 
		build = './install.sh'
	},
	{
		"tpope/vim-obsession",
	},
}
