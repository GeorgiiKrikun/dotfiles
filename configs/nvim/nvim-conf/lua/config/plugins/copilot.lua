return {
	{
		"zbirenbaum/copilot.vim",
		lazy = false,
		--vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
		--  expr = true,
		--  replace_keycodes = false
		--}),
		--vim.g.copilot_no_tab_map = true,
	},
	-- NOTE: Copilot char neovim
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- model = "gemini-2.5-flash",
			-- See Configuration section for options
			mappings = {
				reset = {
					normal = "<C-r>",
					insert = "<C-r>",
				},
			},
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
