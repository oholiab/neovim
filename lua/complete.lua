vim.g.cmptoggle = true

local cmp = require('cmp')
cmp.setup {
  enabled = function()
    return vim.g.cmptoggle
  end
}
vim.keymap.set("n", "<leader>ct", "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>", { desc = "toggle nvim-cmp" })
