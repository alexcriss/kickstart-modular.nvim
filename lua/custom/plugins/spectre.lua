return {
  'nvim-pack/nvim-spectre',
  config = function(opts)
    vim.keymap.set('n', '<leader>St', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = '[S]pectre [Toggle]',
    })
    vim.keymap.set('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = '[S]pectre search current [w]ord',
    })
    vim.keymap.set('v', '<leader>Sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = '[S]pectre search current word',
    })
    vim.keymap.set('n', '<leader>Sf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = '[S]pectre search on current [f]ile',
    })
    require("spectre").setup({
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = {
            "-i",
            "",
            "-E",
          },
        },
      },
    })
  end,
}
