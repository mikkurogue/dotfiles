require('toggleterm').setup({
  direction = 'horizontal',
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return term.name
    end
  }
})
