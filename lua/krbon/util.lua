local M = {}

M.bg = "#000000"
M.fg = "#FFFFFF"

---Turn hex value to rgb table
---@param hex string
---@return table rgb
local function toRgb(hex)
	hex = hex:upper()
	local regex = "#([A-F0-9][A-F0-9])([A-F0-9][A-F0-9])([A-F0-9][A-F0-9])"
	assert(hex:find(regex) ~= nil, "hex_to_rgb: invalid hex string: " .. hex)

	local r, g, b = hex:match(regex)
	return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
---@return string hex blended color
function M.blend(bg, fg, alpha)
	if alpha <= 0 then
		return bg
	elseif alpha >= 1 then
		return fg
	end

	fg = toRgb(fg) ---@diagnostic disable-line:cast-local-type
	bg = toRgb(bg) ---@diagnostic disable-line:cast-local-type

	local function blend(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02X%02X%02X", blend(1), blend(2), blend(3))
end

---Darken color
---@param hex string color to darken
---@param ammount number number between 0 and 1. 0 results in bg, 1 results in fg
---@param bg? string hex color to blend in to darken, defaults to #000000
---@return string hex darkened color
function M.darken(hex, ammount, bg)
	return M.blend(hex, bg or M.bg, math.abs(ammount))
end

---Lighten color
---@param hex string color to lighten
---@param ammount number number between 0 and 1. 0 results in bg, 1 results in fg
---@param fg? string hex color to blend in to darken, defaults to #FFFFFF
---@return string hex lightened color
function M.lighten(hex, ammount, fg)
	return M.blend(hex, fg or M.fg, math.abs(ammount))
end

return M
