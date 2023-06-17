-- font
vim.opt.guifont =  { "Iosevka Nerd Font", ":h12" }
-- keybinds
lvim.keys.insert_mode["jj"] = "<Esc>"
lvim.keys.insert_mode["JJ"] = "<Esc>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- user plugins
lvim.plugins = {
  { "lunarvim/colorschemes" },
  {'pbondoer/vim-42header'},
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
-- colorscheme
lvim.colorscheme = "system76"

