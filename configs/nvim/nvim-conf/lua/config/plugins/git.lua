return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{ -- Side-by-side git diffs and file history using native diff mode
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewFileHistory",
		},
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "[G]it [D]iff (working tree)" },
			{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "[G]it diff [C]lose" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "[G]it [H]istory (current file)" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "[G]it [H]istory (whole repo)" },
			-- Prompt for a revision/range, e.g. `main`, `HEAD~3`, or `main...HEAD`
			{
				"<leader>gb",
				function()
					vim.ui.input({ prompt = "Diff against (rev or range): " }, function(rev)
						if rev and rev ~= "" then
							vim.cmd("DiffviewOpen " .. rev)
						end
					end)
				end,
				desc = "[G]it diff against [B]ranch/rev",
			},
		},
		opts = {
			enhanced_diff_hl = true,
			view = {
				-- Native diff mode: ]c/[c, do/dp, :diffget/:diffput all work as usual
				default = { layout = "diff2_horizontal" },
				merge_tool = { layout = "diff3_horizontal" },
			},
		},
	},
	-- {
	--	"kdheepak/lazygit.nvim",
	--	lazy = true,
	--	cmd = {
	--		"LazyGit",
	--		"LazyGitConfig",
	--		"LazyGitCurrentFile",
	--		"LazyGitFilter",
	--		"LazyGitFilterCurrentFile",
	--	},
	--	-- optional for floating window border decoration
	--	dependencies = {
	--			"nvim-lua/plenary.nvim",
	--	},
	--	-- setting the keybinding for LazyGit with 'keys' is recommended in
	--	-- order to load the plugin when the command is run for the first time
	--	keys = {
	--			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
	--	}
	-- }
}
