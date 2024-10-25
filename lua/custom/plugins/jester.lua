return {
  'David-Kunz/jester',
  config = function(opts)
    vim.keymap.set('n', '<leader>jrc', '<cmd>lua require("jester").run()<CR>', {
      desc = '[J]est [R]un [C]losest',
    })
    vim.keymap.set('n', '<leader>jrf', '<cmd>lua require("jester").run_file()<CR>', {
      desc = '[J]est [R]un [F]ile',
    })
  end,
}
