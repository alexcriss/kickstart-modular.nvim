local bottom = { layout = { preset = 'ivy' } }
local list = { layout = { preset = 'ivy' }, auto_confirm = false, include_current = true }

require('snacks').setup {
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  notifier = { enabled = true },
  input = { enabled = true },
  words = { enabled = true },
  indent = { enabled = true },
  scroll = { enabled = true },
  explorer = { enabled = true },
  dashboard = { enabled = false },
  statuscolumn = { enabled = false },
  picker = {
    enabled = true,
    actions = {
      copy_path = function(picker, item)
        item = item or picker:current()
        if not item then
          return
        end
        local path = Snacks.picker.util.path(item)
        local choices = {
          { 'Basename', vim.fn.fnamemodify(path, ':t') },
          { 'Basename without extension', vim.fn.fnamemodify(path, ':t:r') },
          { 'Relative path', vim.fs.relpath(picker:cwd(), path) or vim.fn.fnamemodify(path, ':.') },
          { 'Home-relative path', vim.fn.fnamemodify(path, ':~') },
          { 'Absolute path', path },
        }
        vim.ui.select(choices, {
          prompt = 'Copy to clipboard',
          format_item = function(c)
            return c[1] .. ': ' .. c[2]
          end,
        }, function(choice)
          if choice then
            vim.fn.setreg('+', choice[2])
            vim.notify('Copied ' .. choice[2])
          end
        end)
      end,
    },
    win = {
      input = { keys = { ['<C-y>'] = { 'copy_path', mode = { 'n', 'i' } } } },
      list = { keys = { ['Y'] = 'copy_path' } },
    },
    sources = {
      files = { hidden = true },
      explorer = { hidden = true },
      grep = bottom,
      grep_word = bottom,
      grep_buffers = bottom,
      lsp_references = list,
      lsp_implementations = list,
      diagnostics = bottom,
      diagnostics_buffer = bottom,
      qflist = bottom,
    },
  },
}

local map = vim.keymap.set
local picker = Snacks.picker

map('n', '<leader><leader>', picker.smart, { desc = 'Smart find (buffers, recent, files)' })
map('n', '<leader>/', picker.files, { desc = 'Find files' })
map('n', '<leader>sg', picker.grep, { desc = 'Grep project' })
map({ 'n', 'x' }, '<leader>sw', picker.grep_word, { desc = 'Grep word / selection' })
map('n', '<leader>s/', picker.grep_buffers, { desc = 'Grep open buffers' })
map('n', '<leader>sb', picker.buffers, { desc = 'Buffers' })
map('n', '<leader>sd', picker.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>sD', picker.diagnostics_buffer, { desc = 'Buffer diagnostics' })
map('n', '<leader>sr', picker.resume, { desc = 'Resume last picker' })
map('n', '<leader>sh', picker.help, { desc = 'Help' })
map('n', '<leader>sk', picker.keymaps, { desc = 'Keymaps' })
map('n', '<leader>sc', picker.command_history, { desc = 'Command history' })
map('n', '<leader>sq', picker.qflist, { desc = 'Quickfix list' })
map('n', '<leader>sj', picker.jumps, { desc = 'Jumps' })
map('n', '<leader>sm', picker.marks, { desc = 'Marks' })
map('n', '<leader>su', picker.undo, { desc = 'Undo history' })
map('n', '<leader>sP', picker.pickers, { desc = 'All pickers' })
map('n', '<leader>sn', function()
  picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Neovim config files' })

local function explorer_focus()
  local explorer = picker.get({ source = 'explorer' })[1]
  if explorer and explorer:is_focused() then
    explorer:close()
  elseif explorer then
    explorer:focus()
  else
    Snacks.explorer()
  end
end
map('n', '\\', explorer_focus, { desc = 'File explorer (focus)' })
map('n', '<leader>e', explorer_focus, { desc = 'File explorer (focus)' })
map('n', '<leader>E', function()
  Snacks.explorer.reveal()
end, { desc = 'Reveal current file in explorer' })

map({ 'n', 'x' }, '<leader>gy', function()
  Snacks.gitbrowse {
    notify = false,
    open = function(url)
      vim.fn.setreg('+', url)
      vim.notify('Copied ' .. url)
    end,
  }
end, { desc = 'Yank git link' })
map({ 'n', 'x' }, '<leader>gY', function()
  Snacks.gitbrowse()
end, { desc = 'Open git link in browser' })
map('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })
map('n', '<leader>gl', picker.git_log, { desc = 'Git log' })
map('n', '<leader>gL', picker.git_log_file, { desc = 'Git log (file)' })
map('n', '<leader>gs', picker.git_status, { desc = 'Git status' })
map('n', '<leader>gb', picker.git_branches, { desc = 'Git branches' })

map('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification history' })

Snacks.toggle.inlay_hints():map '<leader>th'
Snacks.toggle.diagnostics():map '<leader>td'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
Snacks.toggle.option('spell', { name = 'Spell' }):map '<leader>ts'
Snacks.toggle.option('relativenumber', { name = 'Relative number' }):map '<leader>tr'
Snacks.toggle.treesitter():map '<leader>tT'
Snacks.toggle
  .new({
    name = 'Autoformat',
    get = function()
      return vim.g.autoformat ~= false
    end,
    set = function(state)
      vim.g.autoformat = state
    end,
  })
  :map '<leader>tf'
