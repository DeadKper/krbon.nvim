---@class KrbonHighlight
---@field [1] string|nil link or base colors to extend
---@field fg string|nil color for guifg
---@field bg string|nil color for guibg
---@field sp string|nil color for guisp
---@field fmt string|nil string indicating the formats to use, ex: "underline,italic"

---@alias KrbonHighlightGroups table<string, KrbonHighlight>

local M = {}

---Returns highlight group spec
---@param hl string
---@param groups KrbonHighlightGroups
---@return KrbonHighlight spec
local function getAttrs(hl, groups)
	if groups[hl] == nil then
		return {}
	elseif groups[hl][1] ~= nil then
		return vim.tbl_deep_extend("force", {}, getAttrs(groups[hl][1], groups), groups[hl])
	else
		return groups[hl]
	end
end

---@alias KrbonAttribute
---| "fg"
---| "bg"
---| "sp"
---| "fmt"
---| 1

---Get attribute of a highlight group
---@param hl string
---@param attribute KrbonAttribute
---@param groups KrbonHighlightGroups
---@return string|nil
local function attr(hl, attribute, groups)
	return getAttrs(hl, groups)[attribute]
end

---Apply highlight groups
---@param highlights KrbonHighlightGroups
local function apply(highlights)
	for hl, _ in pairs(highlights) do
		local color = getAttrs(hl, highlights)

		if color[1] ~= nil and next(color, 1) == nil then
			vim.cmd.hi("link " .. hl .. " " .. color[1])
		else
			local str = ""
			if color.fg ~= nil then
				str = str .. " guifg=" .. color.fg
			end
			if color.bg ~= nil then
				str = str .. " guibg=" .. color.bg
			end
			if color.sp ~= nil then
				str = str .. " guisp=" .. color.sp
			end
			if color.fmt ~= nil then
				str = str .. " gui=" .. color.fmt
			end

			if str ~= "" then
				vim.cmd.hi(hl .. str)
			end
		end
	end
end

function M.setup()
	local c = require("krbon.colors")
	local cfg = vim.g.krbon
	local util = require("krbon.util")

	---@type KrbonHighlightGroups
	local highlights = {
		-- Transparency
		Normal = { fg = c.fg0, bg = cfg.transparent.background and c.none or c.bg0 },
		NormalFloat = { fg = c.fg0, bg = cfg.transparent.float and c.none or c.bg1 },
		NormalLight = { fg = c.fg0, bg = cfg.transparent.background and c.none or c.bg1 },
		EndOfBuffer = {
			fg = cfg.transparent.background and c.none or (cfg.ending_tildes and c.bg2 or c.bg0),
			bg = cfg.transparent.background and c.none or c.bg0,
		},
		StatusLine = { fg = c.fg0, bg = cfg.transparent.statusline and c.none or c.bg2 },
		StatusLineTerm = { fg = c.fg0, bg = cfg.transparent.statusline and c.none or c.bg2 },
		StatusLineNC = { fg = c.fg2, bg = cfg.transparent.statusline and c.none or c.bg1 },
		StatusLineTermNC = { fg = c.fg2, bg = cfg.transparent.statusline and c.none or c.bg1 },

		-- Vim
		Folded = { "NormalLight" },
		Terminal = { "Normal" },
		FoldColumn = { "NormalLight" },
		SignColumn = { "Normal" },
		ToolbarLine = { fg = c.fg0 },
		Cursor = { fmt = "reverse" },
		vCursor = { fmt = "reverse" },
		iCursor = { fmt = "reverse" },
		lCursor = { fmt = "reverse" },
		CursorIM = { fmt = "reverse" },
		CursorColumn = { bg = c.bg2 },
		CursorLine = { bg = c.bg2 },
		ColorColumn = { bg = c.bg3 },
		CursorLineNr = { fg = c.fg0, fmt = c.none },
		LineNr = { fg = c.fg2 },
		Conceal = { "NormalLight", fg = c.fg1 },
		Added = { fg = c.green },
		Removed = { fg = c.magenta },
		Changed = { fg = c.blue },
		DiffAdd = { fg = c.none, bg = util.darken(c.green, 0.7) },
		DiffChange = { fg = c.none, bg = util.darken(c.blue, 0.7) },
		DiffDelete = { fg = c.none, bg = util.darken(c.magenta, 0.7) },
		DiffText = { fg = c.none, bg = util.darken(c.fg0, 0.7) },
		DiffAdded = { fg = c.green },
		DiffChanged = { fg = c.blue },
		DiffRemoved = { fg = c.magenta },
		DiffDeleted = { fg = c.magenta },
		DiffFile = { fg = c.verdigris },
		DiffIndexLine = { fg = c.fg2 },
		Directory = { fg = c.blue },
		ErrorMsg = { fg = c.magenta, fmt = "bold" },
		WarningMsg = { fg = c.lavender, fmt = "bold" },
		MoreMsg = { fg = c.blue, fmt = "bold" },
		CurSearch = { fg = c.bg0, bg = c.pink },
		IncSearch = { fg = c.bg0, bg = c.pink },
		Search = { fg = c.bg0, bg = util.lighten(c.pink, 0.2) },
		Substitute = { fg = c.bg0, bg = c.lavender },
		MatchParen = { bg = c.none, fmt = "underline" },
		NonText = { fg = c.fg2 },
		Whitespace = { fg = c.fg2 },
		SpecialKey = { fg = c.fg2 },
		Pmenu = { "NormalFloat" },
		PmenuSbar = { "Pmenu", fg = c.none },
		PmenuSel = { fg = c.bg0, bg = util.darken(c.lavender, 0.1) },
		WildMenu = { fg = c.bg0, bg = c.blue },
		PmenuThumb = { fg = c.none, bg = c.bg3 },
		Question = { fg = c.lavender },
		SpellBad = { fg = c.none, fmt = "undercurl", sp = c.magenta },
		SpellCap = { fg = c.none, fmt = "undercurl", sp = c.lavender },
		SpellLocal = { fg = c.none, fmt = "undercurl", sp = c.blue },
		SpellRare = { fg = c.none, fmt = "undercurl", sp = c.pink },
		TabLine = { fg = c.fg0, bg = c.bg1 },
		TabLineFill = { fg = c.fg2, bg = c.bg1 },
		TabLineSel = { fg = c.bg0, bg = c.fg0 },
		WinSeparator = { fg = c.bg3 },
		Visual = { bg = c.bg3 },
		VisualNOS = { fg = c.none, bg = c.bg2, fmt = "underline" },
		QuickFixLine = { fg = c.blue, fmt = "underline" },
		Debug = { fg = c.lavender },
		debugPC = { fg = c.bg0, bg = c.green },
		debugBreakpoint = { fg = c.bg0, bg = c.magenta },
		ToolbarButton = { fg = c.bg0, bg = util.darken(c.lavender, 0.1) },
		FloatBorder = { "NormalFloat", fg = c.fg1 },
		FloatTitle = { "NormalFloat", fg = c.lavender },

		-- Syntax
		String = { fg = c.lavender }, -- strings
		Character = { fg = c.pink },
		Number = { fg = c.cyan },
		Float = { fg = c.cyan },
		Boolean = { fg = c.cyan },
		Type = { fg = c.magenta },
		Structure = { fg = c.magenta },
		StorageClass = { fg = c.magenta },
		Identifier = { fg = c.magenta }, -- variables
		Constant = { fg = c.cyan },
		PreProc = { fg = c.blue },
		PreCondit = { fg = c.blue },
		Include = { fg = c.blue },
		Keyword = { fg = c.blue }, -- keywords
		Define = { fg = c.blue },
		Typedef = { fg = c.magenta },
		Exception = { fg = c.blue },
		Conditional = { fg = c.blue }, -- keywords
		Repeat = { fg = c.blue }, -- keywords
		Statement = { fg = c.blue },
		Macro = { fg = c.magenta },
		Error = { fg = c.blue },
		Label = { fg = c.blue },
		Special = { fg = c.magenta },
		SpecialChar = { fg = c.magenta },
		Function = { fg = c.pink }, -- functions
		Operator = { fg = c.fg0 },
		Title = { fg = c.lavender },
		Tag = { fg = c.lavender },
		Delimiter = { fg = c.fg1 },
		Comment = { fg = c.fg2, fmt = "italic" }, -- comments
		SpecialComment = { fg = c.fg2, fmt = "italic" }, -- comments
		Todo = { fg = c.magenta, fmt = "italic" }, -- comments

		-- Treesitter
		["@annotation"] = { fg = c.fg0 },
		["@attribute"] = { fg = c.sky },
		["@attribute.typescript"] = { fg = c.blue },
		["@boolean"] = { "Boolean" },
		["@character"] = { "Character" },
		["@comment"] = { "Comment" }, -- comments
		["@comment.todo"] = { fg = c.magenta }, -- comments
		["@comment.todo.unchecked"] = { fg = c.magenta }, -- comments
		["@comment.todo.checked"] = { fg = c.green }, -- comments
		["@constant"] = { "Constant" }, -- constants
		["@constant.builtin"] = { "Constant" }, -- constants
		["@constant.macro"] = { "Constant" }, -- constants
		["@constructor"] = { fg = c.magenta, fmt = "bold" },
		["@diff.add"] = { "DiffAdded" },
		["@diff.delete"] = { "DiffDeleted" },
		["@diff.plus"] = { "DiffAdded" },
		["@diff.minus"] = { "DiffDeleted" },
		["@diff.delta"] = { "DiffChanged" },
		["@error"] = { fg = c.fg0 },
		["@function"] = { "Function" }, -- functions
		["@function.builtin"] = { "Function" }, -- functions
		["@function.macro"] = { "Function" }, -- functions
		["@function.method"] = { "Function" }, -- functions
		["@keyword"] = { "Keyword" }, -- keywords
		["@keyword.conditional"] = { "Keyword" }, -- keywords
		["@keyword.directive"] = { "Keyword" },
		["@keyword.exception"] = { "Keyword" },
		["@keyword.function"] = { "Keyword" }, -- functions
		["@keyword.import"] = { "Keyword" },
		["@keyword.operator"] = { "Keyword" }, -- keywords
		["@keyword.repeat"] = { "Keyword" }, -- keywords
		["@label"] = { fg = c.magenta },
		["@markup.emphasis"] = { fg = c.fg0, fmt = "italic" },
		["@markup.environment"] = { fg = c.fg0 },
		["@markup.environment.name"] = { fg = c.fg0 },
		["@markup.heading"] = { fg = c.sky, fmt = "bold" },
		["@markup.link"] = { fg = c.blue },
		["@markup.link.url"] = { fg = c.verdigris, fmt = "underline" },
		["@markup.list"] = { fg = c.magenta },
		["@markup.math"] = { fg = c.fg0 },
		["@markup.raw"] = { fg = c.lavender },
		["@markup.strike"] = { fg = c.fg0, fmt = "strikethrough" },
		["@markup.strong"] = { fg = c.fg0, fmt = "bold" },
		["@markup.underline"] = { fg = c.fg0, fmt = "underline" },
		["@module"] = { fg = c.magenta },
		["@none"] = { fg = c.fg0 },
		["@number"] = { "Number" },
		["@number.float"] = { "Float" },
		["@operator"] = { "Operator" },
		["@parameter.reference"] = { fg = c.fg0 },
		["@property"] = { fg = c.sky },
		["@punctuation.delimiter"] = { fg = c.fg1 },
		["@punctuation.bracket"] = { fg = c.fg1 },
		["@string"] = { "String" }, -- strings
		["@string.regexp"] = { fg = c.pink }, -- strings
		["@string.escape"] = { fg = c.magenta }, -- strings
		["@string.special.symbol"] = { fg = c.sky },
		["@tag"] = { fg = c.blue },
		["@tag.attribute"] = { fg = c.magenta },
		["@tag.delimiter"] = { fg = c.blue },
		["@text"] = { fg = c.fg0 },
		["@note"] = { fg = c.fg0 },
		["@warning"] = { fg = c.fg0 },
		["@danger"] = { fg = c.fg0 },
		["@type"] = { "Type" },
		["@type.builtin"] = { fg = c.sky },
		["@variable"] = { fg = c.fg0 }, -- variables
		["@variable.builtin"] = { fg = c.sky }, -- variables
		["@variable.member"] = { fg = c.sky },
		["@variable.parameter"] = { fg = c.gray },
		["@markup.heading.1.markdown"] = { fg = c.magenta, fmt = "bold" },
		["@markup.heading.2.markdown"] = { fg = c.blue, fmt = "bold" },
		["@markup.heading.3.markdown"] = { fg = c.pink, fmt = "bold" },
		["@markup.heading.4.markdown"] = { fg = c.magenta, fmt = "bold" },
		["@markup.heading.5.markdown"] = { fg = c.blue, fmt = "bold" },
		["@markup.heading.6.markdown"] = { fg = c.pink, fmt = "bold" },
		["@markup.heading.1.marker.markdown"] = { fg = c.magenta, fmt = "bold" },
		["@markup.heading.2.marker.markdown"] = { fg = c.blue, fmt = "bold" },
		["@markup.heading.3.marker.markdown"] = { fg = c.pink, fmt = "bold" },
		["@markup.heading.4.marker.markdown"] = { fg = c.magenta, fmt = "bold" },
		["@markup.heading.5.marker.markdown"] = { fg = c.blue, fmt = "bold" },
		["@markup.heading.6.marker.markdown"] = { fg = c.pink, fmt = "bold" },

		-- Lsp
		["@lsp.type.comment"] = { "@comment" },
		["@lsp.type.enum"] = { "@type" },
		["@lsp.type.enumMember"] = { "@constant.builtin" },
		["@lsp.type.interface"] = { "@type" },
		["@lsp.type.typeParameter"] = { "@type" },
		["@lsp.type.keyword"] = { "@keyword" },
		["@lsp.type.namespace"] = { "@module" },
		["@lsp.type.parameter"] = { "@variable.parameter" },
		["@lsp.type.property"] = { "@property" },
		["@lsp.type.variable"] = { "@variable" },
		["@lsp.type.macro"] = { "@function.macro" },
		["@lsp.type.method"] = { "@function.method" },
		["@lsp.type.number"] = { "@number" },
		["@lsp.type.generic"] = { "@text" },
		["@lsp.type.builtinType"] = { "@type.builtin" },
		["@lsp.typemod.method.defaultLibrary"] = { "@function" },
		["@lsp.typemod.function.defaultLibrary"] = { "@function" },
		["@lsp.typemod.operator.injected"] = { "@operator" },
		["@lsp.typemod.string.injected"] = { "@string" },
		["@lsp.typemod.variable.defaultLibrary"] = { "@variable.builtin" },
		["@lsp.typemod.variable.injected"] = { "@variable" },
		["@lsp.typemod.variable.static"] = { "@constant" },

		LspCxxHlGroupEnumConstant = { fg = c.pink },
		LspCxxHlGroupMemberVariable = { fg = c.pink },
		LspCxxHlGroupNamespace = { fg = c.blue },
		LspCxxHlSkippedRegion = { fg = c.fg2 },
		LspCxxHlSkippedRegionBeginEnd = { fg = c.magenta },

		DiagnosticError = { fg = c.magenta },
		DiagnosticHint = { fg = c.sky },
		DiagnosticInfo = { fg = c.fg0 },
		DiagnosticWarn = { fg = c.lavender },

		DiagnosticVirtualTextError = { fg = cfg.diagnostics.darker and util.darken(c.magenta, 0.35) or c.magenta },
		DiagnosticVirtualTextWarn = { fg = cfg.diagnostics.darker and util.darken(c.lavender, 0.35) or c.lavender },
		DiagnosticVirtualTextInfo = { fg = cfg.diagnostics.darker and util.darken(c.fg0, 0.35) or c.fg0 },
		DiagnosticVirtualTextHint = { fg = cfg.diagnostics.darker and util.darken(c.sky, 0.35) or c.blue },

		DiagnosticUnderlineError = { fmt = "undercurl", sp = c.magenta },
		DiagnosticUnderlineHint = { fmt = "undercurl", sp = c.sky },
		DiagnosticUnderlineInfo = { fmt = "undercurl", sp = c.fg0 },
		DiagnosticUnderlineWarn = { fmt = "undercurl", sp = c.lavender },

		LspReferenceText = { "MatchParen" },
		LspReferenceWrite = { "MatchParen" },
		LspReferenceRead = { "MatchParen" },

		LspCodeLens = { fg = c.fg2 }, -- comments
		LspCodeLensSeparator = { fg = c.fg2 },

		LspDiagnosticsDefaultError = { "DiagnosticError" },
		LspDiagnosticsDefaultHint = { "DiagnosticHint" },
		LspDiagnosticsDefaultInformation = { "DiagnosticInfo" },
		LspDiagnosticsDefaultWarning = { "DiagnosticWarn" },
		LspDiagnosticsUnderlineError = { "DiagnosticUnderlineError" },
		LspDiagnosticsUnderlineHint = { "DiagnosticUnderlineHint" },
		LspDiagnosticsUnderlineInformation = { "DiagnosticUnderlineInfo" },
		LspDiagnosticsUnderlineWarning = { "DiagnosticUnderlineWarn" },
		LspDiagnosticsVirtualTextError = { "DiagnosticVirtualTextError" },
		LspDiagnosticsVirtualTextWarning = { "DiagnosticVirtualTextWarn" },
		LspDiagnosticsVirtualTextInformation = { "DiagnosticVirtualTextInfo" },
		LspDiagnosticsVirtualTextHint = { "DiagnosticVirtualTextHint" },

		-- Plugins

		-- Ale
		ALEErrorSign = { "DiagnosticError" },
		ALEInfoSign = { "DiagnosticInfo" },
		ALEWarningSign = { "DiagnosticWarn" },

		-- Barbar
		BufferCurrent = { fmt = "bold" },
		BufferCurrentMod = { fg = c.pink, fmt = "bold,italic" },
		BufferCurrentSign = { fg = c.blue },
		BufferInactiveMod = { fg = c.fg1, bg = c.bg1, fmt = "italic" },
		BufferVisible = { fg = c.fg1, bg = c.bg0 },
		BufferVisibleMod = { fg = c.lavender, bg = c.bg0, fmt = "italic" },
		BufferVisibleIndex = { fg = c.fg1, bg = c.bg0 },
		BufferVisibleSign = { fg = c.fg1, bg = c.bg0 },
		BufferVisibleTarget = { fg = c.fg1, bg = c.bg0 },

		-- Cmp
		CmpItemAbbr = { fg = c.fg0 },
		CmpItemAbbrDeprecated = { fg = c.fg1, fmt = "strikethrough" },
		CmpItemAbbrMatch = { fg = c.verdigris },
		CmpItemAbbrMatchFuzzy = { fg = c.verdigris, fmt = "underline" },
		CmpItemMenu = { fg = c.fg1 },
		CmpItemKind = { fg = c.blue, fmt = cfg.plugins.cmp_itemkind_reverse and "reverse" or nil },

		-- Coc
		CocErrorSign = { "DiagnosticError" },
		CocHintSign = { "DiagnosticHint" },
		CocInfoSign = { "DiagnosticInfo" },
		CocWarningSign = { "DiagnosticWarn" },

		-- Which Key
		WhichKey = { fg = c.fg0 },
		WhichKeyDesc = { fg = c.lavender },
		WhichKeyGroup = { fg = c.pink },
		WhichKeySeparator = { fg = c.sky },

		-- Git Gutter
		GitGutterAdd = { fg = c.green },
		GitGutterChange = { fg = c.blue },
		GitGutterDelete = { fg = c.magenta },

		-- Hop
		HopNextKey = { fg = c.magenta, fmt = "bold" },
		HopNextKey1 = { fg = c.verdigris, fmt = "bold" },
		HopNextKey2 = { fg = util.darken(c.blue, 0.7) },
		HopUnmatched = { fg = c.fg2 },

		-- Diffview
		DiffviewFilePanelTitle = { fg = c.blue, fmt = "bold" },
		DiffviewFilePanelCounter = { fg = c.cyan, fmt = "bold" },
		DiffviewFilePanelFileName = { fg = c.fg0 },
		DiffviewNormal = { "Normal" },
		DiffviewCursorLine = { "CursorLine" },
		DiffviewVertSplit = { "VertSplit" },
		DiffviewSignColumn = { "SignColumn" },
		DiffviewStatusLine = { "StatusLine" },
		DiffviewStatusLineNC = { "StatusLineNC" },
		DiffviewEndOfBuffer = { "EndOfBuffer" },
		DiffviewFilePanelRootPath = { fg = c.fg2 },
		DiffviewFilePanelPath = { fg = c.fg2 },
		DiffviewFilePanelInsertions = { fg = c.green },
		DiffviewFilePanelDeletions = { fg = c.magenta },
		DiffviewStatusAdded = { fg = c.green },
		DiffviewStatusUntracked = { fg = c.blue },
		DiffviewStatusModified = { fg = c.blue },
		DiffviewStatusRenamed = { fg = c.blue },
		DiffviewStatusCopied = { fg = c.blue },
		DiffviewStatusTypeChange = { fg = c.blue },
		DiffviewStatusUnmerged = { fg = c.blue },
		DiffviewStatusUnknown = { fg = c.magenta },
		DiffviewStatusDeleted = { fg = c.magenta },
		DiffviewStatusBroken = { fg = c.magenta },

		-- Gitsigns
		GitSignsAdd = { fg = c.green },
		GitSignsAddLn = { fg = c.green },
		GitSignsAddNr = { fg = c.green },
		GitSignsChange = { fg = c.blue },
		GitSignsChangeLn = { fg = c.blue },
		GitSignsChangeNr = { fg = c.blue },
		GitSignsDelete = { fg = c.magenta },
		GitSignsDeleteLn = { fg = c.magenta },
		GitSignsDeleteNr = { fg = c.magenta },

		-- Neotree
		NeoTreeNormal = { "Normal" },
		NeoTreeNormalNC = { "Normal" },
		NeoTreeVertSplit = { fg = c.bg1, bg = cfg.transparent.background and c.none or c.bg1 },
		NeoTreeWinSeparator = { fg = c.bg1, bg = cfg.transparent.background and c.none or c.bg1 },
		NeoTreeEndOfBuffer = { "EndOfBuffer" },
		NeoTreeRootName = { fg = c.pink, fmt = "bold" },
		NeoTreeGitAdded = { fg = c.green },
		NeoTreeGitDeleted = { fg = c.magenta },
		NeoTreeGitModified = { fg = c.lavender },
		NeoTreeGitConflict = { fg = c.magenta, fmt = "bold,italic" },
		NeoTreeGitUntracked = { fg = c.magenta, fmt = "italic" },
		NeoTreeIndentMarker = { fg = c.fg2 },
		NeoTreeSymbolicLinkTarget = { fg = c.blue },

		-- Neotest
		NeotestAdapterName = { fg = c.blue, fmt = "bold" },
		NeotestDir = { fg = c.verdigris },
		NeotestExpandMarker = { fg = c.fg2 },
		NeotestFailed = { fg = c.magenta },
		NeotestFile = { fg = c.verdigris },
		NeotestFocused = { fmt = "bold,italic" },
		NeotestIndent = { fg = c.fg2 },
		NeotestMarked = { fg = c.pink, fmt = "bold" },
		NeotestNamespace = { fg = c.blue },
		NeotestPassed = { fg = c.green },
		NeotestRunning = { fg = c.lavender },
		NeotestWinSelect = { fg = c.verdigris, fmt = "bold" },
		NeotestSkipped = { fg = c.fg1 },
		NeotestTarget = { fg = c.blue },
		NeotestTest = { fg = c.fg0 },
		NeotestUnknown = { fg = c.fg1 },

		-- Nvim Tree
		NvimTreeNormal = { fg = c.fg0, bg = cfg.transparent.background and c.none or c.bg0 },
		NvimTreeVertSplit = { fg = c.bg0, bg = cfg.transparent.background and c.none or c.bg1 },
		NvimTreeEndOfBuffer = { "EndOfBuffer" },
		NvimTreeRootFolder = { fg = c.pink, fmt = "bold" },
		NvimTreeGitDirty = { fg = c.lavender },
		NvimTreeGitNew = { fg = c.green },
		NvimTreeGitDeleted = { fg = c.magenta },
		NvimTreeSpecialFile = { fg = c.lavender, fmt = "underline" },
		NvimTreeIndentMarker = { fg = c.fg0 },
		NvimTreeImageFile = { fg = util.darken(c.sky, 0.2) },
		NvimTreeSymlink = { fg = c.cyan },
		NvimTreeFolderName = { fg = c.blue },

		-- Telescope
		TelescopeNormal = { "NormalFloat" },
		TelescopeTitle = { "FloatTitle" },
		TelescopeBorder = { "FloatBorder" },
		TelescopePromptBorder = { "TelescopeBorder" },
		TelescopeResultsBorder = { "TelescopeBorder" },
		TelescopePreviewBorder = { "TelescopeBorder" },
		TelescopeMatching = { fg = c.pink, fmt = "bold" },
		TelescopePromptPrefix = { fg = c.lavender },
		TelescopeSelectionCaret = { fg = c.lavender },

		-- Dashboard
		DashboardShortCut = { fg = c.blue },
		DashboardHeader = { fg = c.lavender },
		DashboardCenter = { fg = c.verdigris },
		DashboardFooter = { fg = util.darken(c.magenta, 0.2), fmt = "italic" },

		-- Outline
		FocusedSymbol = { fg = c.blue, bg = c.bg2, fmt = "bold" },
		AerialLine = { fg = c.blue, bg = c.bg2, fmt = "bold" },

		-- Navic
		NavicText = { fg = c.fg0 },
		NavicSeparator = { fg = c.fg1 },

		-- Ts Rainbow
		rainbowcol1 = { fg = c.fg1 },
		rainbowcol2 = { fg = c.lavender },
		rainbowcol3 = { fg = c.blue },
		rainbowcol4 = { fg = c.pink },
		rainbowcol5 = { fg = c.cyan },
		rainbowcol6 = { fg = c.green },
		rainbowcol7 = { fg = c.magenta },

		-- Ts Rainbow 2
		TSRainbowRed = { fg = c.magenta },
		TSRainbowYellow = { fg = c.lavender },
		TSRainbowBlue = { fg = c.blue },
		TSRainbowOrange = { fg = c.pink },
		TSRainbowGreen = { fg = c.green },
		TSRainbowViolet = { fg = c.cyan },
		TSRainbowCyan = { fg = c.verdigris },

		-- Rainbow Delimiters
		RainbowDelimiterRed = { fg = c.magenta },
		RainbowDelimiterYellow = { fg = c.lavender },
		RainbowDelimiterBlue = { fg = c.blue },
		RainbowDelimiterOrange = { fg = c.pink },
		RainbowDelimiterGreen = { fg = c.green },
		RainbowDelimiterViolet = { fg = c.cyan },
		RainbowDelimiterCyan = { fg = c.verdigris },

		-- Indent Blankline
		IndentBlanklineIndent1 = { fg = c.blue },
		IndentBlanklineIndent2 = { fg = c.green },
		IndentBlanklineIndent3 = { fg = c.verdigris },
		IndentBlanklineIndent4 = { fg = c.fg1 },
		IndentBlanklineIndent5 = { fg = c.cyan },
		IndentBlanklineIndent6 = { fg = c.magenta },
		IndentBlanklineChar = { fg = c.bg1, fmt = "nocombine" },
		IndentBlanklineContextChar = { fg = c.fg2, fmt = "nocombine" },
		IndentBlanklineContextStart = { sp = c.fg2, fmt = "underline" },
		IndentBlanklineContextSpaceChar = { fmt = "nocombine" },

		-- Indent Blankline v3
		IblIndent = { fg = c.bg1, fmt = "nocombine" },
		IblWhitespace = { fg = c.fg2, fmt = "nocombine" },
		IblScope = { fg = c.fg2, fmt = "nocombine" },

		-- Leap
		LeapMatch = { "CurSearch", fmt = "reverse,bold,nocombine" },
		LeapLabelPrimary = { "CurSearch" },
		LeapLabelSecondary = { "Substitute" },

		-- Mini
		MiniCompletionActiveParameter = { fmt = "underline" },

		MiniCursorword = { fmt = "underline" },
		MiniCursorwordCurrent = { fmt = "underline" },

		MiniIndentscopeSymbol = { fg = c.fg2 },
		MiniIndentscopePrefix = { fmt = "nocombine" }, -- Make it invisible

		MiniJump = { fg = c.cyan, fmt = "underline", sp = c.cyan },

		MiniJump2dSpot = { fg = c.magenta, fmt = "bold,nocombine" },

		MiniStarterCurrent = { fmt = "nocombine" },
		MiniStarterFooter = { fg = util.darken(c.magenta, 0.2), fmt = "italic" },
		MiniStarterHeader = { fg = c.lavender },
		MiniStarterInactive = { fg = c.fg2 }, -- comments
		MiniStarterItem = { fg = c.fg0, bg = cfg.transparent.background and c.none or c.bg0 },
		MiniStarterItemBullet = { fg = c.fg2 },
		MiniStarterItemPrefix = { fg = c.lavender },
		MiniStarterSection = { fg = c.fg1 },
		MiniStarterQuery = { fg = c.verdigris },

		MiniStatuslineDevinfo = { fg = c.fg0, bg = c.bg2 },
		MiniStatuslineFileinfo = { fg = c.fg0, bg = c.bg2 },
		MiniStatuslineFilename = { fg = c.fg2, bg = c.bg1 },
		MiniStatuslineInactive = { fg = c.fg2, bg = c.bg0 },
		MiniStatuslineModeCommand = { fg = c.bg0, bg = c.lavender, fmt = "bold" },
		MiniStatuslineModeInsert = { fg = c.bg0, bg = c.blue, fmt = "bold" },
		MiniStatuslineModeNormal = { fg = c.bg0, bg = c.green, fmt = "bold" },
		MiniStatuslineModeOther = { fg = c.bg0, bg = c.verdigris, fmt = "bold" },
		MiniStatuslineModeReplace = { fg = c.bg0, bg = c.magenta, fmt = "bold" },
		MiniStatuslineModeVisual = { fg = c.bg0, bg = c.cyan, fmt = "bold" },

		MiniSurround = { fg = c.bg0, bg = c.pink },

		MiniTablineCurrent = { fmt = "bold" },
		MiniTablineFill = { fg = c.fg2, bg = c.bg1 },
		MiniTablineHidden = { fg = c.fg0, bg = c.bg1 },
		MiniTablineModifiedCurrent = { fg = c.pink, fmt = "bold,italic" },
		MiniTablineModifiedHidden = { fg = c.fg1, bg = c.bg1, fmt = "italic" },
		MiniTablineModifiedVisible = { fg = c.lavender, bg = c.bg0, fmt = "italic" },
		MiniTablineTabpagesection = { fg = c.bg0, bg = util.lighten(c.pink, 0.2) },
		MiniTablineVisible = { fg = c.fg1, bg = c.bg0 },

		MiniTestEmphasis = { fmt = "bold" },
		MiniTestFail = { fg = c.magenta, fmt = "bold" },
		MiniTestPass = { fg = c.green, fmt = "bold" },

		MiniTrailspace = { bg = c.magenta },

		-- Langs

		-- C
		cInclude = { fg = c.blue },
		cStorageClass = { fg = c.cyan },
		cTypedef = { fg = c.cyan },
		cDefine = { fg = c.verdigris },
		cTSInclude = { fg = c.blue },
		cTSConstant = { "Constant" },
		cTSConstMacro = { fg = c.cyan },
		cTSOperator = { fg = c.cyan },

		-- C++
		cppStatement = { fg = c.cyan, fmt = "bold" },
		cppTSInclude = { fg = c.blue },
		cppTSConstant = { "Constant" },
		cppTSConstMacro = { fg = c.cyan },
		cppTSOperator = { fg = c.cyan },

		-- Markdown
		markdownBlockquote = { fg = c.fg2 },
		markdownBold = { fg = c.none, fmt = "bold" },
		markdownBoldDelimiter = { fg = c.fg2 },
		markdownCode = { fg = c.green },
		markdownCodeBlock = { fg = c.green },
		markdownCodeDelimiter = { fg = c.lavender },
		markdownH1 = { fg = c.magenta, fmt = "bold" },
		markdownH2 = { fg = c.blue, fmt = "bold" },
		markdownH3 = { fg = c.pink, fmt = "bold" },
		markdownH4 = { fg = c.magenta, fmt = "bold" },
		markdownH5 = { fg = c.blue, fmt = "bold" },
		markdownH6 = { fg = c.pink, fmt = "bold" },
		markdownHeadingDelimiter = { fg = c.fg2 },
		markdownHeadingRule = { fg = c.fg2 },
		markdownId = { fg = c.lavender },
		markdownIdDeclaration = { fg = c.magenta },
		markdownItalic = { fg = c.none, fmt = "italic" },
		markdownItalicDelimiter = { fg = c.fg2, fmt = "italic" },
		markdownLinkDelimiter = { fg = c.fg2 },
		markdownLinkText = { fg = c.magenta },
		markdownLinkTextDelimiter = { fg = c.fg2 },
		markdownListMarker = { fg = c.magenta },
		markdownOrderedListMarker = { fg = c.magenta },
		markdownRule = { fg = c.pink },
		markdownUrl = { fg = c.blue, fmt = "underline" },
		markdownUrlDelimiter = { fg = c.fg2 },
		markdownUrlTitleDelimiter = { fg = c.green },

		-- Php
		phpFunctions = { fg = c.fg0 }, -- functions
		phpMethods = { fg = c.verdigris },
		phpStructure = { fg = c.blue },
		phpOperator = { fg = c.blue },
		phpMemberSelector = { fg = c.fg0 },
		phpVarSelector = { fg = c.pink }, -- variables
		phpIdentifier = { fg = c.pink }, -- variables
		phpBoolean = { "Boolean" },
		phpNumber = { fg = c.pink },
		phpHereDoc = { fg = c.green },
		phpNowDoc = { fg = c.green },
		phpSCKeyword = { fg = c.cyan }, -- keywords
		phpFCKeyword = { fg = c.cyan }, -- keywords
		phpRegion = { fg = c.blue },

		-- Scala
		scalaNameDefinition = { fg = c.fg0 },
		scalaInterpolationBoundary = { fg = c.blue },
		scalaInterpolation = { fg = c.blue },
		scalaTypeOperator = { fg = c.magenta },
		scalaOperator = { fg = c.magenta },
		scalaKeywordModifier = { fg = c.magenta }, -- keywords

		-- Tex
		latexTSInclude = { fg = c.blue },
		latexTSFuncMacro = { fg = c.fg0 }, -- functions
		latexTSEnvironment = { fg = c.verdigris, fmt = "bold" },
		latexTSEnvironmentName = { fg = c.lavender },
		texCmdEnv = { fg = c.verdigris },
		texEnvArgName = { fg = c.lavender },
		latexTSTitle = { fg = c.green },
		latexTSType = { fg = c.blue },
		latexTSMath = { fg = c.pink },
		texMathZoneX = { fg = c.pink },
		texMathZoneXX = { fg = c.pink },
		texMathDelimZone = { fg = c.fg1 },
		texMathDelim = { fg = c.cyan },
		texMathOper = { fg = c.magenta },
		texCmd = { fg = c.cyan },
		texCmdPart = { fg = c.blue },
		texCmdPackage = { fg = c.blue },
		texPgfType = { fg = c.lavender },

		-- Vim
		vimOption = { fg = c.magenta },
		vimSetEqual = { fg = c.lavender },
		vimMap = { fg = c.cyan },
		vimMapModKey = { fg = c.pink },
		vimNotation = { fg = c.magenta },
		vimMapLhs = { fg = c.fg0 },
		vimMapRhs = { fg = c.blue },
		vimVar = { fg = c.fg0 }, -- variables
		vimCommentTitle = { fg = c.fg1 }, -- comments
	}

	local lsp_kind_icons_color = {
		Default = c.cyan,
		Array = c.lavender,
		Boolean = attr("Boolean", "fg", highlights),
		Class = c.lavender,
		Color = c.lavender,
		Constant = attr("Constant", "fg", highlights),
		Constructor = c.blue,
		Enum = c.cyan,
		EnumMember = c.lavender,
		Event = c.lavender,
		Field = c.cyan,
		File = c.pink,
		Folder = c.blue,
		Function = c.blue,
		Interface = c.lavender,
		Key = c.verdigris,
		Keyword = c.verdigris,
		Method = c.blue,
		Module = c.pink,
		Namespace = c.magenta,
		Null = c.fg2,
		Number = attr("Number", "fg", highlights),
		Object = c.magenta,
		Operator = attr("Operator", "fg", highlights),
		Package = c.lavender,
		Property = attr("@property", "fg", highlights),
		Reference = c.pink,
		Snippet = c.magenta,
		String = attr("String", "fg", highlights),
		Struct = c.cyan,
		Text = c.fg1,
		TypeParameter = c.magenta,
		Unit = c.green,
		Value = c.pink,
		Variable = c.cyan,
	}

	for kind, color in pairs(lsp_kind_icons_color) do
		highlights["CmpItemKind" .. kind] = { fg = color, fmt = cfg.plugins.cmp_itemkind_reverse and "reverse" or nil }
		highlights["Aerial" .. kind .. "Icon"] = { fg = color }
		highlights["NavicIcons" .. kind] = { fg = color }
	end

	if cfg.highlights then
		for key, value in pairs(cfg.highlights) do
			highlights[key] = value
		end
	end

	apply(highlights)
end

return M
