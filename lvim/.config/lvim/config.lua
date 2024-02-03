-- font
vim.opt.guifont = { "Iosevka Nerd Font", ":h16" }
-- keybinds
lvim.keys.insert_mode["jj"] = "<Esc>"
lvim.keys.insert_mode["JJ"] = "<Esc>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- runing pylint
-- lvim.lang.python.linters = { { exe = "pylint" } }

-- user plugins
lvim.plugins = {
  {
    'nvie/vim-flake8'
  },
  {
"ChristianChiarulli/swenv.nvim"
},
{"stevearc/dressing.nvim"},
{"mfussenegger/nvim-dap-python"},
{"nvim-neotest/neotest"},
{"nvim-neotest/neotest-python"},
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  { 'github/copilot.vim' },
  { "lunarvim/colorschemes" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { 'loctvl842/monokai-pro.nvim' },
  { "iamcco/markdown-preview.nvim" },
  { 'pbondoer/vim-42header' },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    's1n7ax/nvim-search-and-replace',
    config = function()
      require('nvim-search-and-replace').setup({
        replace_keymap = '<leader>sR',
      })
    end,
  }
}
local pyright_opts = {
  single_file_support = true,
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "basic",   -- off, basic, strict
        useLibraryCodeForTypes = true
      }
    }
  },
}

require("lvim.lsp.manager").setup("pyright", pyright_opts)
-- lvim.lang.python.linters = { { exe = "pylint" } }
require("lvim.lsp.manager").setup("tsserver")
-- require("lvim.lsp.manager").setup("volar")

-- require("lvim.lsp.manager").setup("pylyzer")
-- require("lvim.lsp.manager").setup("pyright", pyright_opts)
-- require("lvim.lsp.manager").setup("dockerls")
-- require("lvim.lsp.manager").setup("yamlls")
-- require("lvim.lsp.manager").setup("vimls")
-- require("lvim.lsp.manager").setup("gopls")
-- require("lvim.lsp.manager").setup("rust_analyzer")
-- require("lvim.lsp.manager").setup("sumneko_lua")
require("lvim.lsp.manager").setup("lus_ls")
-- require("lvim.lsp.manager").setup("bashls")
require("lvim.lsp.manager").setup("jsonls")
-- require("lvim.lsp.manager").setup("html")
-- require("lvim.lsp.manager").setup("cssls")
-- require("lvim.lsp.manager").setup("graphql")
-- require("lvim.lsp.manager").setup("terraformls")
-- require("lvim.lsp.manager").setup("efm")
-- require("lvim.lsp.manager").setup("vuels")
-- require("lvim.lsp.manager").setup("tailwindcss")
-- require("lvim.lsp.manager").setup("dartls")
-- require("lvim.lsp.manager").setup("denols")


--[[ require('swenv').setup({
  -- Should return a list of tables with a `name` and a `path` entry each.
  -- Gets the argument `venvs_path` set below.
  -- By default just lists the entries in `venvs_path`.
  get_venvs = function(venvs_path)
    return require('swenv.api').get_venvs(venvs_path)
  end,
  -- Path passed to `get_venvs`.
  venvs_path = vim.fn.expand('~/venvs'),
  -- Something to do after setting an environment, for example call vim.cmd.LspRestart
  post_set_venv = nil,
}) ]]

-- copilot config
vim.g.copilot_no_tab_map = false
vim.g.copilot_assume_mapped = false
-- lvim.keys.insert_mode["<C-k>"] = "copilot#Previous()"
-- lvim.keys.insert_mode["<C-j>"] = "copilot#Next()"
-- lvim.keys.insert_mode["<C-o>"] = ':copilot#Accept("<CR>")'

vim.api.nvim_set_keymap("i", "<C-Tab>", "copilot#Accept()", { silent = false, expr = true })

-- python IDE -----------------------------------------------------------------------

-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }
lvim.format_on_save.enabled = false
lvim.format_on_save.pattern = { "*.py" }

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", filetypes = { "python" } } }

-- setup debug adapter
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
  "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }


-- binding for switching
lvim.builtin.which_key.mappings["CE"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}

-- colorscheme
lvim.colorscheme = "monokai-pro-octagon"
