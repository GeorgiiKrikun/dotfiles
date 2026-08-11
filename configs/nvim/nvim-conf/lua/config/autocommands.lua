vim.api.nvim_create_autocmd("WinEnter", {
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
	end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

-- When neovim is opened without a file, open the current directory in oil.nvim
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		-- No file/dir arguments and the starting buffer is empty and unnamed
		if vim.fn.argc() == 0 and vim.fn.line2byte(vim.fn.line("$")) == -1 and vim.api.nvim_buf_get_name(0) == "" then
			-- Defer so oil's async directory scan runs after startup finishes,
			-- otherwise the listing renders empty.
			vim.schedule(function()
				require("oil").open(vim.fn.getcwd())
			end)
		end
	end,
})

-- Load custom commands from a file custom.lua
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local cwd = vim.fn.getcwd()
		local custom_lua = cwd .. "/.nvim/custom.lua"
		if vim.fn.filereadable(custom_lua) == 1 then
			vim.notify("Loading custom commands from: " .. custom_lua, vim.log.levels.INFO)
			dofile(custom_lua)
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
