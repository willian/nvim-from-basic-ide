local colorscheme = "night-owl"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

if colorscheme == "night-owl" then
  -- Separate the Editor from the Sidebar
  -- https://github.com/sdras/night-owl-vscode-theme#separate-the-editor-from-the-sidebar
  vim.api.nvim_command("highlight NvimTreeWinSeparator guifg=#102a44 guibg=#000c1d")
  vim.api.nvim_command("highlight NvimTreeNormal guifg=#8badc1 guibg=#000c1d")
  vim.api.nvim_command("highlight NvimTreeNormalNC guifg=#8badc1 guibg=#000c1d")
  vim.api.nvim_command("highlight NvimTreeEndOfBuffer guifg=#000c1d guibg=#000c1d")
  vim.api.nvim_command("highlight CursorLine guibg=#01121F")

  -- Better highlight color for vim-illuminate
  vim.api.nvim_exec([[
    augroup illuminate_augroup
      autocmd!
      autocmd VimEnter * hi illuminatedWord guibg=#2E475C
    augroup END
  ]], true)
end

