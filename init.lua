-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or vim.loop.fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

vim.opt.tabstop = 4

-- quickfix list delete keymap
function Remove_qf_item()
  local curqfidx = vim.fn.line "."
  local qfall = vim.fn.getqflist()

  -- Return if there are no items to remove
  if #qfall == 0 then return end

  -- Remove the item from the quickfix list
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, "r")

  -- Reopen quickfix window to refresh the list
  vim.cmd "copen"

  -- If not at the end of the list, stay at the same index, otherwise, go one up.
  local new_idx = curqfidx < #qfall and curqfidx or math.max(curqfidx - 1, 1)

  -- Set the cursor position directly in the quickfix window
  local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
  vim.api.nvim_win_set_cursor(winid, { new_idx, 0 })
end

vim.cmd "command! RemoveQFItem lua Remove_qf_item()"
vim.api.nvim_command "autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<cr>"

