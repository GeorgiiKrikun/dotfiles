local function show_messages_in_scratch()
  local mes_out = vim.api.nvim_exec2("messages", {output = true}).output

  vim.cmd('new')

  vim.bo[0].buftype = 'nofile'
  vim.bo[0].bufhidden = 'hide'
  vim.bo[0].swapfile = false
  vim.bo[0].filetype = 'messages'

  local lines = vim.split(mes_out, '\n')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.bo[0].modifiable = false
  vim.api.nvim_win_set_cursor(0, {1, 0}) -- {row, col}
end

-- Create the custom command that calls our Lua function
vim.api.nvim_create_user_command('Messages', show_messages_in_scratch, {})

-- Open the newest Claude Code session transcript for the current project as a
-- readable, searchable scratch buffer. TUI apps like `claude` run on the
-- alternate screen and can't be scrolled or `/`-searched inside :terminal, so
-- this renders the on-disk transcript instead where j/k, / and ? all work.
local function open_claude_log()
  local cwd = vim.fn.getcwd()
  -- Claude Code names its project dir by replacing every non-alphanumeric
  -- character of the cwd with '-'.
  local mangled = cwd:gsub('%W', '-')
  local dir = vim.fn.expand('~/.claude/projects/') .. mangled
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify('No Claude transcripts for ' .. cwd, vim.log.levels.WARN)
    return
  end

  local files = vim.fn.globpath(dir, '*.jsonl', false, true)
  if #files == 0 then
    vim.notify('No Claude .jsonl transcripts in ' .. dir, vim.log.levels.WARN)
    return
  end
  table.sort(files, function(a, b)
    return vim.fn.getftime(a) > vim.fn.getftime(b)
  end)
  local file = files[1]

  local out = {}
  local function push(s)
    for _, l in ipairs(vim.split(s or '', '\n', { plain = true })) do
      out[#out + 1] = l
    end
  end

  local function render_content(content)
    if type(content) == 'string' then
      push(content)
      return
    end
    if type(content) ~= 'table' then
      return
    end
    for _, block in ipairs(content) do
      local t = block.type
      if t == 'text' then
        push(block.text)
      elseif t == 'thinking' then
        push('[thinking]')
        push(block.thinking)
      elseif t == 'tool_use' then
        push('→ tool_use: ' .. tostring(block.name))
      elseif t == 'tool_result' then
        push('← [tool result]')
      end
    end
  end

  for _, line in ipairs(vim.fn.readfile(file)) do
    if line ~= '' then
      local ok, obj = pcall(vim.json.decode, line)
      if ok and type(obj) == 'table' and (obj.type == 'user' or obj.type == 'assistant') then
        local role = (obj.message and obj.message.role) or obj.type
        push('')
        push('════════════════ ' .. string.upper(role) .. ' ════════════════')
        render_content(obj.message and obj.message.content)
      end
    end
  end

  vim.cmd('tabnew')
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = 'markdown'
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.bo[buf].modifiable = false
  pcall(vim.api.nvim_buf_set_name, buf, '[Claude] ' .. vim.fn.fnamemodify(file, ':t'))
  vim.wo.wrap = true
  -- Land on the most recent message; search backward with ? from here.
  vim.api.nvim_win_set_cursor(0, { math.max(1, #out), 0 })
  vim.cmd('normal! zz')
end

vim.api.nvim_create_user_command('ClaudeLog', open_claude_log, {})
