local function table_merge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				table_merge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
local function table_print(tbl, indent)
	if not indent then
		indent = 0
	end
	for k, v in pairs(tbl) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			table_print(v, indent + 1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end

return {
	table_merge = table_merge,
	table_print = table_print,
}
