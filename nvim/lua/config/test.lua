
local M = {}

local keymap = vim.api.nvim_set_keymap

local function keymaps()
  local opts = { noremap = false, silent = true }
  keymap("n", "[t", "<Plug>(ultest-prev-fail)", opts)
  keymap("n", "]t", "<Plug>(ultest-next-fail)", opts)
end

local function config_test()
  vim.api.nvim_exec(
    [[
        " Test config
        let test#strategy = "neovim"
        let test#neovim#term_position = "belowright"
        let g:test#preserve_screen = 1
        let g:ultest_use_pty = 1
        " Python
        let test#python#runner = 'pyunit'
        " let test#python#runner = 'pytest'
    ]],
    false
  )
end

local function python_debugger(cmd)
  local non_modules = { "python", "pipenv", "poetry" }
  local module_index = 1
  if vim.tbl_contains(non_modules, cmd[1]) then
    module_index = 3
  end
  local module = cmd[module_index]

  local args = vim.list_slice(cmd, module_index + 1)
  return {
    dap = {
      type = "python",
      request = "launch",
      module = module,
      args = args,
    },
  }
end

local function config_ultest()
  local builders = {
    ["python#pytest"] = python_debugger,
    ["python#pyunit"] = python_debugger,
  }
  require("ultest").setup { builders = builders }
end

function M.setup()
  config_test()
  config_ultest()
  keymaps()
end

return M