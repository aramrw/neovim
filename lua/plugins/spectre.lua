-- Correct lazy.nvim setup for nvim-spectre
return {
  'nvim-pack/nvim-spectre',
  config = function()
    -- This code runs after the plugin is loaded
    require('spectre').setup()

    -- Keymaps are also set here
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = "Toggle Spectre"
    })
    vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = "Search current word"
    })
    vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = "Search current word"
    })
    vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = "Search on current file"
    })
  end,
  -- other plugin configuration options, like dependencies, can go here
}
