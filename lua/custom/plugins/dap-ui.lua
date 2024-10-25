return {
  'rcarriga/nvim-dap-ui',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio', 'theHamsta/nvim-dap-virtual-text' },
  opts = {
    layouts = {
      {
        elements = {
          {
            id = 'scopes',
            size = 0.25,
          },
          {
            id = 'breakpoints',
            size = 0.25,
          },
          {
            id = 'stacks',
            size = 0.25,
          },
          {
            id = 'watches',
            size = 0.25,
          },
        },
        position = 'left',
        size = 60,
      },
      {
        elements = { {
          id = 'repl',
          size = 1,
        } },
        position = 'right',
        size = 80,
      },
    },
  },
  config = function(_, opts)
    local dap, dapui, dapvt = require 'dap', require 'dapui', require 'nvim-dap-virtual-text'

    -- setup
    dapui.setup(opts)
    dapvt.setup()

    -- icons
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })

    -- shortcuts
    local n = 'n'
    vim.keymap.set(n, '<leader>dbs', function()
      require('dap').continue()
    end)
    vim.keymap.set(n, '<leader>dbt', function()
      require('dap').terminate()
    end)
    vim.keymap.set(n, '<leader>bt', function()
      require('dap').toggle_breakpoint()
    end)

    -- open and close automagically
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
