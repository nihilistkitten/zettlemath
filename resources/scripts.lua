local M = {}

local function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

local function dedup(tab)
	local hash = {}
	local ret = {}

	for _, v in ipairs(tab) do
		if not hash[v] then
			ret[#ret + 1] = v -- you could print here instead of saving to result table if you wanted
			hash[v] = true
		end
	end

	return ret
end

local function run(cmd)
	local handle = io.popen(cmd)
	if not handle then
		print("error starting process")
		print(handle)
		os.exit(-1)
	end
	local ret = {}
	for line in handle:lines() do
		if line ~= "" then
			table.insert(ret, line)
		end
	end
	handle:close()
	return ret
end

local function tags_of(file)
	return run("pdfinfo " .. file .. [[ | rg Keywords | tr -s ' ' | cut -d " " -f 2- | sed "s/, /\n/g"]])
end

local function has_tag(file, tag)
	return has_value(tags_of(file), tag)
end

local function list_pdfs()
	return run([[find notes -name "*.pdf"]])
end

M.strip_filename = function(file)
	return file:match(".+/(.+)%..+$")
end

M.list_tags = function()
	local pdfs = list_pdfs()
	local tags = {}
	for _, pdf in ipairs(pdfs) do
		for _, tag in ipairs(tags_of(pdf)) do
			table.insert(tags, tag)
		end
	end

	return dedup(tags)
end

M.files_with_tag = function(tag)
	local pdfs = list_pdfs()
	local ret = {}
	for _, pdf in ipairs(pdfs) do
		if has_tag(pdf, tag) then
			table.insert(ret, pdf)
		end
	end

	return ret
end

return M
