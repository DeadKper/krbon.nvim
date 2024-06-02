local c = require("krbon.colors")
local cfg = vim.g.krbon

local krbon = {
	inactive = {
		a = { fg = c.gray, bg = c.bg0, gui = "bold" },
		b = { fg = c.gray, bg = c.bg0 },
		c = { fg = c.gray, bg = cfg.transparent.statusline and c.none or c.bg1 },
	},
	normal = {
		a = { fg = c.bg0, bg = c.lavender, gui = "bold" },
		c = { fg = c.fg0, bg = cfg.transparent.statusline and c.none or c.bg1 },
	},
	visual = { a = { fg = c.bg0, bg = c.blue, gui = "bold" } },
	replace = { a = { fg = c.bg0, bg = c.magenta, gui = "bold" } },
	insert = { a = { fg = c.bg0, bg = c.pink, gui = "bold" } },
	command = { a = { fg = c.bg0, bg = c.green, gui = "bold" } },
	terminal = { a = { fg = c.bg0, bg = c.fg0, gui = "bold" } },
}

for key, value in pairs(krbon) do
	if key ~= "inactive" then
		value.b = {
			fg = value.a.bg,
			bg = value.a.fg,
			gui = "bold",
		}
	end
end

return krbon
