return {
  'David-Kunz/jester',
  opts = {
  },
  config = function()
    require("jester").setup({
      path_to_jest_run = './node_modules/.bin/jest',   -- used to run tests
      path_to_jest_debug = './node_modules/.bin/jest', -- used for debugging
    })
    vim.keymap.set('n', '<leader>jrc', '<cmd>lua require("jester").run()<CR>', {
      desc = '[J]est [R]un [C]losest',
    })
    vim.keymap.set('n', '<leader>jrf', '<cmd>lua require("jester").run_file()<CR>', {
      desc = '[J]est [R]un [F]ile',
    })
  end,
}
