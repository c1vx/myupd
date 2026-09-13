ddoptionbutton.MouseButton1Down:Connect(function()
			local find = table.find(multibox.current, v)
			if find == nil then
				table.insert(multibox.current, v)
				ddoptiontitle.TextColor3 = self.library.theme.accent
				table.insert(self.library.themeitems["accent"]["TextColor3"], ddoptiontitle)
			else
				table.remove(multibox.current, find)
				ddoptiontitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				local idx = table.find(self.library.themeitems["accent"]["TextColor3"], ddoptiontitle)
				if idx then table.remove(self.library.themeitems["accent"]["TextColor3"], idx) end
			end

			local str = table.concat(multibox.current, ", ")
			value.Text = str
			multibox.callback(multibox.current)
		end)
	end

	dropdownbutton.MouseButton1Down:Connect(function()
		multibox.library:closewindows(multibox)
		optionsholder.Visible = not multibox.open
		multibox.open = not multibox.open
		indicator.Text = multibox.open and "-" or "+"
	end)

	local pointer = props.pointer or props.Pointer or props.pointername or props.Pointername or props.PointerName or props.pointerName or nil
	if pointer and self.pointers then
		self.pointers[tostring(pointer)] = multibox
	end

	self.library.labels[#self.library.labels+1] = title
	self.library.labels[#self.library.labels+1] = value

	setmetatable(multibox, multiboxs)
	return multibox
end

function multiboxs:set(values)
	if typeof(values) == "table" then
		self.current = values
		self.value.Text = table.concat(values, ", ")
		for _, title in pairs(self.titles) do
			if table.find(values, title.Text) then
				title.TextColor3 = self.library.theme.accent
			else
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
		self.callback(values)
	end
end