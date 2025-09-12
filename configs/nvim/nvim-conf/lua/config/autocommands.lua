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

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
