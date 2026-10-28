local dap = require 'dap'
local dv = require 'dap-view'

dv.setup {
  auto_toggle = true,
  windows = { size = 0.3 },
  winbar = {
    sections = { 'scopes', 'watches', 'breakpoints', 'threads', 'exceptions', 'repl', 'console' },
    default_section = 'scopes',
    controls = { enabled = true },
  },
  virtual_text = { enabled = true },
}

require('dap-go').setup { delve = { detached = vim.fn.has 'win32' == 0 } }

dap.adapters.python = { type = 'executable', command = 'debugpy-adapter' }
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch current file',
    program = '${file}',
    console = 'integratedTerminal',
    pythonPath = function()
      return vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python3'
    end,
  },
}

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', numhl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', numhl = 'DiagnosticWarn' })
vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DapLogPoint', { text = '◉', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticOk', linehl = 'Visual', numhl = 'DiagnosticOk' })

local function conditional_breakpoint()
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(cond)
    if cond then
      dap.set_breakpoint(cond)
    end
  end)
end

local map = vim.keymap.set
map('n', '<F5>', dap.continue, { desc = 'Debug: continue / start' })
map('n', '<F10>', dap.step_over, { desc = 'Debug: step over' })
map('n', '<F11>', dap.step_into, { desc = 'Debug: step into' })
map('n', '<S-F11>', dap.step_out, { desc = 'Debug: step out' })
map('n', '<leader>dc', dap.continue, { desc = 'Continue / start' })
map('n', '<leader>dC', dap.run_to_cursor, { desc = 'Run to cursor' })
map('n', '<leader>do', dap.step_over, { desc = 'Step over' })
map('n', '<leader>di', dap.step_into, { desc = 'Step into' })
map('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
map('n', '<leader>dB', conditional_breakpoint, { desc = 'Conditional breakpoint' })
map('n', '<leader>dx', dap.clear_breakpoints, { desc = 'Clear breakpoints' })
map('n', '<leader>dl', dap.run_last, { desc = 'Run last' })
map('n', '<leader>dt', dap.terminate, { desc = 'Terminate' })
map('n', '<leader>du', '<cmd>DapViewToggle<CR>', { desc = 'Toggle debug view' })
map('n', '<leader>dw', '<cmd>DapViewWatch<CR>', { desc = 'Watch expression under cursor' })
map({ 'n', 'x' }, '<leader>de', function()
  dv.hover(nil, true)
end, { desc = 'Evaluate expression' })
map('n', '<leader>dg', function()
  require('dap-go').debug_test()
end, { desc = 'Debug nearest Go test' })

map({ 'n', 'x' }, 'K', function()
  if dap.session() then
    dv.hover(nil, true)
  elseif #vim.lsp.get_clients { bufnr = 0 } > 0 then
    vim.lsp.buf.hover()
  else
    vim.cmd 'normal! K'
  end
end, { desc = 'Hover (LSP) / evaluate (debug)' })

map('n', '<2-LeftMouse>', function()
  if dap.session() then
    dv.hover(vim.fn.expand '<cword>', false)
    return ''
  end
  return '<2-LeftMouse>'
end, { expr = true, desc = 'Evaluate word under mouse while debugging' })

function _G.StatusColumnClick(_, _, button)
  local pos = vim.fn.getmousepos()
  if pos.winid == 0 or pos.line == 0 then
    return
  end
  vim.api.nvim_set_current_win(pos.winid)
  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 0 })
  if button == 'l' then
    dap.toggle_breakpoint()
  elseif button == 'r' then
    conditional_breakpoint()
  end
end

vim.o.statuscolumn = '%@v:lua.StatusColumnClick@%s%=%l %X'
