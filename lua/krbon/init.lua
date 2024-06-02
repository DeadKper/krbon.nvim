local M = {}

function M.colorscheme()
	vim.cmd.hi("clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.g.colors_name = "krbon"
	vim.o.termguicolors = true
	vim.o.background = "dark"

	require("krbon.highlights").setup()
end

---@param config KrbonConfig
function M.setup(config)
	local defaults = require("krbon.config")

	local function deep_copy(tbl, copy)
		for key, value in pairs(tbl) do
			if copy[key] then
				if type(value) == "table" then
					deep_copy(value, copy[key])
				else
					tbl[key] = copy[key]
				end
			end
		end
	end

	if type(config) == "table" then
		deep_copy(defaults, config)
	end

	vim.g.krbon = defaults
end

function M.load()
	vim.cmd.colorscheme("krbon")
end

return M
