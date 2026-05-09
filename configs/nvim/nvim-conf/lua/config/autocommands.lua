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

-- Set foldmethod=expr per-buffer after treesitter attaches via FileType + schedule
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_folds", { clear = true }),
    callback = function(args)
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then return end
            if vim.bo[args.buf].buftype ~= "" then return end
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end)
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
