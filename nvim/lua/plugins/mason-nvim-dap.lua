return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    handlers = {
      -- C/C++ configuration using cppdbg
      cppdbg = function(source_name)
        local dap = require "dap"

        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = vim.fn.exepath "OpenDebugAD7", -- mason installs this
        }

        dap.configurations.c = {
          {
            name = "Launch C file",
            type = "cppdbg",
            request = "launch",
            program = function()
              local file = vim.fn.expand "%:p:r"
              os.execute(string.format("clang -g -o %s %s", file, vim.fn.expand "%:p"))
              return file
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
          {
            name = "Launch C file (manual)",
            type = "cppdbg",
            request = "launch",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
        }

        dap.configurations.cpp = {
          {
            name = "Launch C++ file",
            type = "cppdbg",
            request = "launch",
            program = function()
              local file = vim.fn.expand "%:p:r"
              os.execute(string.format("clang++ -g -o %s %s", file, vim.fn.expand "%:p"))
              return file
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
          {
            name = "Launch C++ file (manual)",
            type = "cppdbg",
            request = "launch",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
            },
          },
        }
      end,
    },
  },
}
