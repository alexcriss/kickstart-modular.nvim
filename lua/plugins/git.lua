require('gitsigns').setup {
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  on_attach = function(bufnr)
    local gs = require 'gitsigns'
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gs.nav_hunk 'next'
      end
    end, 'Next git change')
    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gs.nav_hunk 'prev'
      end
    end, 'Previous git change')

    map('v', '<leader>hs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, 'Stage hunk')
    map('v', '<leader>hr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, 'Reset hunk')
    map('n', '<leader>hs', gs.stage_hunk, 'Stage / unstage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hb', gs.blame_line, 'Blame line')
    map('n', '<leader>hd', gs.diffthis, 'Diff against index')
    map('n', '<leader>hD', function()
      gs.diffthis '@'
    end, 'Diff against last commit')
    map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
    map('n', '<leader>tD', gs.toggle_deleted, 'Toggle deleted lines')
  end,
}

local function difftool(args)
  vim.system(vim.list_extend({ 'git', 'difftool', '--dir-diff', '--no-prompt' }, args), { detach = true })
end
vim.keymap.set('n', '<leader>gd', function()
  difftool {}
end, { desc = 'Difftool: working tree vs index' })
vim.keymap.set('n', '<leader>gD', function()
  vim.ui.input({ prompt = 'Diff against (rev or range)', default = 'HEAD' }, function(rev)
    if rev and rev ~= '' then
      difftool(vim.split(rev, ' ', { trimempty = true }))
    end
  end)
end, { desc = 'Difftool: working tree vs revision' })
