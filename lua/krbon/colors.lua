---@class KrbonColors hex colors
---@field bg0 string base background color
---@field bg1 string base float background color
---@field bg2 string bg0 highlighted
---@field bg3 string bg1 highlighted
---@field fg0 string base white color
---@field fg1 string gray color
---@field fg2 string dimmer gray
---@field none string always none
---@field blue string
---@field green string
---@field lavender string
---@field magenta string
---@field pink string
---@field verdigris string
---@field gray string
---@field sky string
---@field cyan string

---Returns colors
---@return KrbonColors
local function load_colors()
	local colors = require("krbon.palette")

	for key, value in pairs(vim.g.krbon.colors) do
		colors[key] = value
	end
	colors.none = "NONE"

	return colors
end

return load_colors()
