function read_file(filename)
  local file = io.open(filename, 'r')
  if not file then
    return nil
  end
  local content = file:read '*a'
  file:close()
  return content
end

--local function find_project_root()
--  local current_dir = vim.fn.expand '%:p:h'
--  log_message('Current directory: ' .. current_dir)
--  local path_parts = vim.split(current_dir, '/')
--
--  while #path_parts > 0 do
--    local check_path = table.concat(path_parts, '/')
--    if vim.fn.filereadable(check_path .. '/Cargo.toml') == 1 or vim.fn.filereadable(check_path .. '/compile_commands.json') == 1 then
--      log_message('Project root found: ' .. check_path)
--      return check_path
--    end
--    table.remove(path_parts)
--  end
--  return nil -- Project root not found
--end
--
--
--local function load_local_config()
--  local project_root = find_project_root()
--  log_message('Project root: ' .. (project_root or 'not found'))
--  if project_root then
--    local file_content = read_file(project_root .. '/.nvimrc.local')
--    log_message('Local config content: ' .. (file_content or 'not found'))
--    if file_content then
--      log_message 'get to file content'
--      -- Split the content into individual lines (commands)
--      local commands = vim.split(file_content, '\n', { trimempty = true })
--      -- Execute each command
--      for _, cmd in ipairs(commands) do
--        if cmd ~= '' then -- Ensure the command is not empty
--          log_message('Executing command: ' .. cmd)
--          vim.cmd(cmd)
--        end
--      end
--    end
--  end
--end
--
--vim.api.nvim_create_autocmd({ 'BufEnter' }, {
--  pattern = { '*' },
--  callback = load_local_config,
--})
