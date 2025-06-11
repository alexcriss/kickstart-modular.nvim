return {
  'folke/trouble.nvim',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble quickfix toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    {
      '<leader>xp',
      function()
        local trouble = require 'trouble'
        trouble.prev()
        trouble.refresh()
        trouble.jump()
      end,
      desc = 'Jump to next (Trouble)',
    },
    {
      '<leader>xn',
      function()
        local trouble = require 'trouble'
        trouble.next()
        trouble.refresh()
        trouble.jump()
      end,
      desc = 'Jump to next (Trouble)',
    },
  },
  config = function()
    require('trouble').setup()
    -- hijack other windows with trouble https://github.com/folke/trouble.nvim/issues/70#issuecomment-1528094026
    local function use_trouble()
      local trouble = require 'trouble'
      -- Check whether we deal with a quickfix or location list buffer, close the window and open the
      -- corresponding Trouble window instead.
      if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
        vim.defer_fn(function()
          vim.cmd.lclose()
          vim.cmd [[Trouble loclist open auto_refresh=false]]
        end, 0)
      else
        vim.defer_fn(function()
          vim.cmd.cclose()
          vim.cmd [[Trouble quickfix open auto_refresh=false]]
        end, 0)
      end
    end
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'qf' },
      callback = use_trouble,
    })
  end,
}
