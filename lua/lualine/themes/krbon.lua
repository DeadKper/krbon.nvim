local c = require("krbon.colors")
local cfg = vim.g.krbon

local bg = {
	a = c.bg0,
	b = c.bg2,
	c = cfg.transparent.statusline and c.none or c.bg1,
}

local krbon = {
	inactive = {
		a = { fg = c.fg1, bg = bg.a, gui = "bold" },
		b = { fg = c.fg1, bg = bg.b },
		c = { fg = c.fg1, bg = bg.c },
	},
	normal = {
		a = { bg = c.lavender },
		c = { fg = c.fg0, bg = bg.c },
	},
	visual = { a = { bg = c.blue } },
	replace = { a = { bg = c.magenta } },
	insert = { a = { bg = c.pink } },
	command = { a = { bg = c.green } },
	terminal = { a = { bg = c.fg0 } },
}

for key, value in pairs(krbon) do
	if key ~= "inactive" then
		value.b = {
			fg = value.a.bg,
			bg = bg.b,
			gui = "bold",
		}

		value.a.fg = bg.b
		value.a.gui = "bold"
	end
end

return krbon
