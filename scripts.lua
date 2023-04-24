local M = {}

M.get_tags = function()
	local handle = io.popen(
		[[find notes -name "*.pdf" -exec pdfinfo "{}" \; | rg Keywords | tr -s ' ' | cut -d " " -f 2- | sed "s/, /\n/g" | sort | uniq]]
	)
	if not handle then
		print("BIG ERROR")
		print(handle)
		os.exit(-1)
	end
	local ret = {}
	for line in handle:lines() do
		table.insert(ret, line)
	end
	handle:close()
	return ret
end

M.tags = M.get_tags()

return M
