
CaretOnSwitchFile = EventClass:new(Common)
CaretOnFileOpen = EventClass:new(Common)

function CaretOnFileOpen:OnOpen(fn)

	--~ split up fullfilepath
	path, filename, ext = string.match(fn, "(.-)([^\\]-([^\\%.]+))$")
    if ext ~= '' then
		if props['caret.' .. ext .. '.line.back'] ~= '' then
			props['caret.line.back'] = props['caret.' .. ext .. '.line.back']
		else
			props['caret.line.back'] = props['caret.default.line.back']
		end

		if props['caret.' .. ext .. '.fore'] ~= '' then
			props['caret.fore'] = props['caret.' .. ext .. '.fore']
		else
			props['caret.fore'] = props['caret.default.fore']
		end
	end

end

function CaretOnSwitchFile:OnSwitchFile(fn)

	path, filename, ext = string.match(fn, "(.-)([^\\]-([^\\%.]+))$")
	if ext ~= '' then
		if props['caret.' .. ext .. '.line.back'] ~= '' then
			lineback = props['caret.' .. ext .. '.line.back']
		else
			lineback = props['caret.default.line.back']
		end

		if props['caret.' .. ext .. '.fore'] ~= '' then
			fore = props['caret.' .. ext .. '.fore']
		else
			fore = props['caret.default.fore']
		end
	end
	--~ these commands takes color values as BBGGRR even though all property colors are defined as RRGGBB. Brilliant!!
	editor.CaretLineBack = tonumber(string.sub(lineback, 6, 7) .. string.sub(lineback, 4, 5) .. string.sub(lineback, 2, 3), 16)
	editor.CaretFore = tonumber(string.sub(fore, 6, 7) .. string.sub(fore, 4, 5) .. string.sub(fore, 2, 3), 16)

end
