local function show_messages_in_scratch()
  local stringx = require("pl.stringx")
  local mes_out = vim.api.nvim_exec2("messages", {output = true}).output

  vim.cmd('new')

  vim.bo[0].buftype = 'nofile'
  vim.bo[0].bufhidden = 'hide'
  vim.bo[0].swapfile = false
  vim.bo[0].filetype = 'messages'

  local lines = stringx.split(mes_out, '\n')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.bo[0].modifiable = false
  vim.api.nvim_win_set_cursor(0, {1, 0}) -- {row, col}
end

-- Create the custom command that calls our Lua function
vim.api.nvim_create_user_command('Messages', show_messages_in_scratch, {})


