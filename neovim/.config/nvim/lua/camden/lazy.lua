local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "camden.plugins" }, { import = "camden.plugins.lsp" } }, {
  install = {
    colorscheme = { "no-clown-fiesta" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy menu" }) -- toggle file explorer
