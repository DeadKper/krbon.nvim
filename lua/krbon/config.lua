---@class KrbonConfigAccent
---@field color string color to use as accent, defaults to #9134CC
---@field enabled boolean enable accent color to be used
---@field highlight boolean use accent to also highlight selections, matching parents, string search, etc...
---@field foreground boolean use highlight in foreground instead of background where possible

---@class KrbonConfigDiagnostics
---@field darker boolean darker colors for diagnostic

---@class KrbonConfigPlugins
---@field cmp_itemkind_reverse boolean use reverse in cmp itemkind

---@class KrbonConfigTransparency
---@field background boolean make background transparent
---@field float boolean make float background transparent
---@field statusline boolean make statusline background transparent

---@class KrbonConfig
---@field term_colors boolean enable terminal colors
---@field cmp_itemkind_reverse boolean reverse item kind highlights in cmp menu
---@field ending_tildes boolean reverse item kind highlights in cmp menu
---@field transparency KrbonConfigTransparency transparency config
---@field accent KrbonConfigAccent accent config
---@field colors KrbonColors override default colors
---@field highlights KrbonHighlight override highlight groups
---@field diagnostics KrbonConfigDiagnostics diagnostic configs
local M = {
	-- Main options

	term_colors = true,
	ending_tildes = false,

	transparency = {
		background = false,
		float = false,
		statusline = false,
	},

	-- Accent options

	accent = {
		color = "#9134CC",
		enabled = false,
		highlight = false,
		foreground = false,
	},

	-- Plugins

	plugins = {
		cmp_itemkind_reverse = false,
	},

	-- Custom Highlights

	colors = {},
	highlights = {},

	-- Plugins Related

	diagnostics = {
		darker = true,
	},
}

return M
