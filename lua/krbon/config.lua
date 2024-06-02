---@class KrbonConfigDiagnostics
---@field darker boolean darker colors for diagnostic

---@class KrbonConfigPlugins
---@field cmp_itemkind_reverse boolean use reverse in cmp itemkind

---@class KrbonConfigTransparency
---@field background boolean make background transparent
---@field float boolean make float background transparent
---@field statusline boolean make statusline background transparent

---@class KrbonConfig
---@field ending_tildes boolean reverse item kind highlights in cmp menu
---@field transparent KrbonConfigTransparency transparency config
---@field plugins KrbonConfigPlugins plugins config
---@field colors KrbonColors override default colors
---@field highlights KrbonHighlight override highlight groups
---@field diagnostics KrbonConfigDiagnostics diagnostic configs
local M = {
	-- Main options
	ending_tildes = false,

	-- Transparency options
	transparent = {
		background = false,
		float = false,
		statusline = false,
	},

	-- Plugins
	plugins = {
		cmp_itemkind_reverse = false,
	},

	-- Custom highlights
	colors = {}, ---@diagnostic disable-line:missing-fields
	highlights = {},

	-- Plugins related
	diagnostics = {
		darker = true,
	},
}

return M
