return {
  {
    "camdenwithrow/cams-colors.nvim",
    -- "kvrohit/mellow.nvim",
    priority = 1000,
    config = function()
      require("no-clown-fiesta").setup({
        styles = {},
      })
      vim.cmd([[colorscheme no-clown-fiesta]])
    end,
  },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({})
  --     vim.cmd([[colorscheme kanagawa-dragon]])
  --   end,
  -- },
}
