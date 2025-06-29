return {
	{
		"sakhnik/nvim-gdb",
		config = function()
			vim.keymap.set("n", "<leader>dr", ":GdbRun<CR>", { desc = "[D]ebug [R]un" })
		end,
	},

}
