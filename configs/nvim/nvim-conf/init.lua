local log_file = vim.fn.expand("~/.nvim_local_config_log") -- Choose your log file path

local function log_message(message)
	local file = io.open(log_file, "a")
	if file then
		file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")
		file:close()
	end
end

log_message("Starting Neovim configuration...")

require("config.options") -- Load options
require("config.hotkeys") -- Load keymaps
require("config.autocommands") -- Load autocommands

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set default foldmethod to indent
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"

require("local_config")

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.cmd([[
  cnoreabbrev W w
  cnoreabbrev Wq wq
  cnoreabbrev WQ wq
  cnoreabbrev Q q
  cnoreabbrev Qa qa
  cnoreabbrev QA qa
]])
-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
  require("lazy").setup({
    require("config.plugins.copilot"),
    require("config.plugins.core"),
    require("config.plugins.debug"),
    require("config.plugins.git"),
    require("config.plugins.lsp"),
    require("config.plugins.themes"),
    require("config.plugins.ui"),
  }, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
