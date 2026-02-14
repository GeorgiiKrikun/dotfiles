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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "h", "hpp", "cu", "cuh" },
  callback = function()
    print("Setting tabstop and shiftwidth for C/C++ files")
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Preserve indentation on empty lines when saving
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("indent_blank_lines", { clear = true }),
	callback = function()
		if not vim.bo.modifiable or vim.bo.buftype ~= "" then
			return
		end
		local n_lines = vim.api.nvim_buf_line_count(0)
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local changed = false

		local ts_indent = nil
		local has_ts, ts_module = pcall(require, "nvim-treesitter.indent")
		if has_ts and ts_module.get_indent then
			ts_indent = ts_module.get_indent
		end

		for i = 1, n_lines do
			local line = lines[i]
			if line:match("^%s*$") then
				local indent = -1
				if ts_indent then
					indent = ts_indent(i)
				end

				if indent == nil or indent < 0 then
					indent = vim.fn.indent(i)
				end

				if indent > 0 then
					local indent_str
					if vim.bo.expandtab then
						indent_str = string.rep(" ", indent)
					else
						local tabstop = vim.bo.tabstop or 8
						indent_str = string.rep("\t", math.floor(indent / tabstop)) .. string.rep(" ", indent % tabstop)
					end
					if indent_str ~= line then
						lines[i] = indent_str
						changed = true
					end
				end
			end
		end

		if changed then
			local view = vim.fn.winsaveview()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
			vim.fn.winrestview(view)
		end
	end,
})
