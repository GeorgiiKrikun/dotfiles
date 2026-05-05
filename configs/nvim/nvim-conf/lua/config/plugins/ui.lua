return {
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
    {
        "letieu/jira.nvim",
        opts = {
            -- Your setup options...
            jira = {
                limit = 200,                                -- Global limit of tasks per view (default: 200)
            },
            projects = {
                ["CEL"] = {
                    story_point_field = "customfield_10016",      -- Custom field ID for story points
                }
            }
        },
    },
    {
        'MisanthropicBit/winmove.nvim',
        keymaps = {
            help = "?", -- Open floating window with help for the current mode
            help_close = "q", -- Close the floating help window
            quit = "q", -- Quit current mode
            toggle_mode = "<tab>", -- Toggle between modes when in a mode
        },
        config = function(_, _)
            vim.keymap.set("n", "<C-w>m", ":lua require(\"winmove\").start_mode(\"move\")<CR>", { desc = "Enter move mode" })
            vim.keymap.set("n", "<C-w>r", ":lua require(\"winmove\").start_mode(\"resize\")<CR>", { desc = "Enter resize mode" })
        end,
    }
	-- lazy.nvim
	-- {
	--   "folke/noice.nvim",
	--   event = "VeryLazy",
	--   opts = {
	--     -- add any options here
	--   },
	--   dependencies = {
	--     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	--     "MunifTanjim/nui.nvim",
	--     -- -- OPTIONAL:
	--     -- --   `nvim-notify` is only needed, if you want to use the notification view.
	--     -- --   If not available, we use `mini` as the fallback
	--     -- "rcarriga/nvim-notify",
	--     }
	-- }
}
