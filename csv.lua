local _debug = false

return function(export_md, str)
	if not str and type(export_md) == 'string' then
		str = export_md
		export_md = {}
	end
	if not export_md then
		export_md = {}
	end
	local keys = {}
	local line1start, line1end = str:find('^[^\n]+\n')
	for key in str:sub(line1start, line1end-1):gmatch('[^,]+') do
		table.insert(keys, key)
	end
	local data = {}
	for line in str:sub(line1end+1):gmatch('[^\n]+') do
		local entry = {}
		local empty = true
		local key = 1
		local charindex = 1
		while charindex <= #line do
			local char = line:sub(charindex, charindex)
			if char == ',' then
				key = key + 1
				charindex = charindex + 1
			else
				local _, e, value = line:find('([^,]+)', charindex)
				if char == '"' then
					_, e, value = line:find('([^"]+)', charindex)
					e = e + 1
					while line:sub(e, e+1) == '""' do
						local _, newE, v = line:find('([^"]+)', e+2)
						if newE then
							e = newE + 1
						else
							e = e + 2
						end
						value = value .. '"' .. (v or '')
					end
--					value = value:sub(2)
				end
				if e and value then
					local keyname = keys[key]
					if (not export_md.exclude or not export_md.exclude[keyname]) and (not export_md.include or export_md.include[keyname]) then
						value = tonumber(value) or value
						if export_md.map and export_md.map[keyname] then
							value = export_md.map[keyname](value)
						end
						if value ~= nil then
							entry[keyname] = value
							empty = false
						end
					end
					key = key + 1
					charindex = e + 2
				end
			end
		end
		if not empty then
			table.insert(data, entry)
			if _debug then
				local s = ''
				for key, value in pairs(entry) do
					s = s .. key .. ' = ' .. tostring(value) .. ', '
				end
				print(s)
			end
		end
	end
	return data
end
-- 2022-01-03T10:21:48

-- 2022-01-03T15:16:30

-- 2022-01-05T18:43:23

-- 2022-01-06T21:19:09

-- 2022-01-08T16:04:42

-- 2022-01-08T14:28:47

-- 2022-01-09T22:27:13

-- 2022-01-12T19:40:23

-- 2022-01-13T19:57:50

-- 2022-01-14T21:34:06

-- 2022-01-16T11:28:52

-- 2022-01-16T09:35:48

-- 2022-01-16T15:25:06

-- 2022-01-17T20:45:20

-- 2022-01-17T09:38:52

-- 2022-01-17T18:28:36

-- 2022-01-17T11:22:25

-- 2022-01-18T18:55:20

-- 2022-01-20T17:44:43

-- 2022-01-22T19:08:41

-- 2022-01-24T14:41:50

-- 2022-01-24T16:32:08

-- 2022-01-26T13:53:01

-- 2022-01-26T14:41:47

-- 2022-01-27T19:12:22

-- 2022-01-27T17:23:47

-- 2022-01-28T15:42:27

-- 2022-01-30T16:01:02

-- 2022-01-31T20:03:17

-- 2022-02-02T10:30:53

-- 2022-02-02T11:15:51

-- 2022-02-02T13:03:00

-- 2022-02-03T13:14:12

-- 2022-02-05T17:31:48

-- 2022-02-05T12:37:26

-- 2022-02-10T10:29:28

-- 2022-02-10T12:15:01

-- 2022-02-11T16:16:39

-- 2022-02-11T20:45:20

-- 2022-02-13T20:29:32

-- 2022-02-16T12:09:58

-- 2022-02-18T22:21:52

-- 2022-02-22T17:18:15

-- 2022-02-26T16:11:27

-- 2022-02-27T20:25:38

-- 2022-02-28T10:02:01

-- 2022-02-28T21:52:47

-- 2022-02-28T11:21:34

-- 2022-03-01T12:12:06

-- 2022-03-01T17:34:53

-- 2022-03-04T20:49:51

-- 2022-03-05T12:38:02

-- 2022-03-05T16:44:21

-- 2022-03-05T14:19:07
