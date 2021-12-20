local M = {}
local api = vim.api

local ns = api.nvim_create_namespace('hihex')

local on_line = function(_, _, bufnr, row)
	local line = api.nvim_buf_get_lines(bufnr, row, row+1, true)[1]
	local col = 1
	local nr = 1
	while true do
		local s, e = string.find(line, '[%w_]*#[%w_#]+', col)
		if not s then break end
		col = e+1

		local m = string.sub(line, s, e)
		if not string.find(m, '^#%x%x%x%x%x%x$') then break end

		vim.notify('Found match '..m..' at '..s, 0)

		local hl_group = 'HiHex'..nr
		nr = nr + 1
		vim.cmd('hi! '..hl_group..' guifg=#ffffff guibg='..m)

		api.nvim_buf_set_extmark(bufnr, ns, row, s-1, {
			end_line = row,
			end_col = e,
			hl_group = hl_group,
			hl_mode = 'combine',
			virt_text = {{'●', hl_group}},
			
			ephemeral = true,
		})

	end
	return true
end

M.setup = function()
	print("setting "..vim.inspect(ns))
	api.nvim_set_decoration_provider(ns, {
		on_win = function() return true end,
		on_line = on_line,
	})
end

M._hotreload = function()
	require('hihex').setup()
end

M.debug = function()
	DEBUG_HIHEX = true
end

return M
