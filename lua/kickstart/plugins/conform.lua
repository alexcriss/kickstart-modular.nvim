return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    config = function()
      local formatters_by_ft = {
        -- lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettier', 'eslint_d', stop_after_first = true },
        typescript = { 'prettier', 'eslint_d', stop_after_first = true },
      }
      if not vim.env.SSH_TTY then
        formatters_by_ft['lua'] = { 'stylua' }
      end
      require('conform').setup {
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true, sh = true, json = true, jsonc = true }
          if vim.env.SSH_TTY then
            disable_filetypes = { c = true, cpp = true, sh = true, json = true, jsonc = true, lua = true, php = true }
          end
          local lsp_format_opt
          if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 20000,
            lsp_format = lsp_format_opt,
          }
        end,
        formatters_by_ft = formatters_by_ft,
      }
    end,
  },
}
