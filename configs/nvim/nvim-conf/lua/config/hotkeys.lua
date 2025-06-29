-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set("n", "<leader>H", ":ClangdSwitchSourceHeader<CR>", { desc = "Switch Header/Source" })
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--close and delete the current buffer
vim.keymap.set("n", "<C-w>bd", ":bd<CR>", { desc = "Close and delete current buffer" })

-- Delete the selection without yanking it
vim.keymap.set("n", "D", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("v", "D", '"_d', { desc = "Delete without yanking (visual mode)" })
vim.keymap.set("n", "X", '"_x', { desc = "Delete char without yanking" })
vim.keymap.set("v", "X", '"_x', { desc = "Delete char without yanking (visual mode)" })
vim.keymap.set("n", "C", '"_c', { desc = "Replace without yanking" })
vim.keymap.set("v", "C", '"_c', { desc = "Replace without yanking (visual mode)" })
vim.keymap.set("n", "<leader>ot", ":tabnew | terminal<CR>izsh<CR>", { desc = "Open terminal in new tab" })
vim.keymap.set("n", "<leader>Lca", ":lua vim.lsp.buf.code_action()<CR>", { desc = "LSP Code [A]ction" })

-- Insert carriage return in normal mode
vim.keymap.set("n", "<S-CR>", "i<CR><Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-CR>", "a<CR><Esc>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>i", "i <Esc>", { silent = true })

-- Open neogit status window
vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", { desc = "Open [G]it [S]tatus" })

-- Copilot keymaps
-- vim.keymap.set('n', '<leader>cc', ':CopilotChat<CR>', { desc = 'Open Copilot [C]hat' })
vim.keymap.set("n", "<leader>ct", ":CopilotChatToggle<CR>", { desc = "[C]opilot Chat [T]oggle" })
vim.keymap.set("n", "<leader>cd", ":CopilotChatDocs<CR>", { desc = "[C]opilot Chat [D]ocs" })
vim.keymap.set("n", "<leader>cc", ":CopilotChatCommit<CR>", { desc = "[C]opilot Chat [C]ommit" })
vim.keymap.set("n", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "[C]opilot Chat [E]xplain" })
vim.keymap.set("v", "<leader>ce", ":'<,'>CopilotChatExplain<CR>", { desc = "[C]opilot Chat [E]xplain" })

-- Diagnostic keymaps
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>Q", vim.cmd.copen, { desc = "Open diagnostic [Q]uickfix window" })
vim.keymap.set("n", "<leader>C", vim.cmd.cclose, { desc = "Close diagnostic [C]lose window" })

vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
-- Evaluate the word or range under the cursor LLDB/GDB
--
-- vim.keymap.set("n", "<leader>de", ":GdbEvalWord<CR>", { desc = "Evaluate word under cursor" })
-- vim.keymap.set("v", "<leader>de", ":GdbEvalRange<CR>", { desc = "Evaluate range under cursor" })

vim.keymap.set("n", "<leader>Ct", ":tabclose<CR>", { desc = "[C]lose current  [T]ab" })

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic [L]ine" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Nvim tree toggle

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
