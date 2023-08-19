
local BitBuffer = {}

--[[
String Encoding:
	   Char 1   Char 2
str:  LSB--MSB LSB--MSB
Bit#  1,2,...8 9,...,16
--]]

local DISABLE_WARNINGS = false

local NumberToBase64; local Base64ToNumber; do
	NumberToBase64 = {}
	Base64ToNumber = {}
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	for i = 1, #chars do
		local ch = chars:sub(i, i)
		NumberToBase64[i-1] = ch
		Base64ToNumber[ch] = i-1
	end
end

local PowerOfTwo; do
	PowerOfTwo = {}
	for i = 0, 64 do
		PowerOfTwo[i] = 2^i
	end
end

local BrickColorToNumber; local NumberToBrickColor; do
	BrickColorToNumber = {}
	NumberToBrickColor = {}
	for i = 0, 63 do
		local color = BrickColor.palette(i)
		BrickColorToNumber[color.Number] = i
		NumberToBrickColor[i] = color
	end
end
BrickColorToNumber[1005] = 42 -- Why do I need to do this??? I write Hot pink otherwise...
NumberToBrickColor[42] = BrickColor.new('Deep orange')

local floor,insert = math.floor, table.insert
local function ToBase(n, b)
    n = floor(n)
    if not b or b == 10 then return tostring(n) end
    local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local t = {}
    local sign = ""
    if n < 0 then
        sign = "-"
    n = -n
    end
    repeat
        local d = (n % b) + 1
        n = floor(n / b)
        insert(t, 1, digits:sub(d, d))
    until n == 0
    return sign..table.concat(t, "")
end

function BitBuffer.Create()
	local this = {}
	
	-- Tracking
	local mBitPtr = 0
	local mBitBuffer = {}
	
	function this:ResetPtr()
		mBitPtr = 0
	end
	function this:Reset()
		mBitBuffer = {}
		mBitPtr = 0
	end
	
	function this:Eof() -- wait, when we FromBase64, we get extra 0's... :/
		return mBitPtr >= #mBitBuffer
	end
	
	function this:GetData() -- returns the raw buffer table, then resets itself as a security measure
		local b = mBitBuffer
		self:Reset()
		return b
	end
	
--	function this:GetPtr() return mBitPtr end
	
	-- Set debugging on
	local mDebug = false
	function this:SetDebug(state)
		mDebug = state
	end
	
	-- Read / Write to a string
	function this:FromString(str)
		this:Reset()
		for i = 1, #str do
			local ch = str:sub(i, i):byte()
			for i = 1, 8 do
				mBitPtr = mBitPtr + 1
				mBitBuffer[mBitPtr] = ch % 2
				ch = math.floor(ch / 2)
			end
		end
		mBitPtr = 0
	end
	function this:ToString()
		local str = ""
		local accum = 0
		local pow = 0
		for i = 1, math.ceil((#mBitBuffer) / 8)*8 do
			accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
			pow = pow + 1
			if pow >= 8 then
				str = str..string.char(accum)
				accum = 0
				pow = 0
			end
		end
		return str
	end
	
	-- Read / Write to base64
	function this:FromBase64(str)
		this:Reset()
		for i = 1, #str do
			local ch = Base64ToNumber[str:sub(i, i)]
			assert(ch, "Bad character: 0x"..ToBase(str:sub(i, i):byte(), 16))
			for i = 1, 6 do
				mBitPtr = mBitPtr + 1
				mBitBuffer[mBitPtr] = ch % 2
				ch = math.floor(ch / 2)
			end
			assert(ch == 0, "Character value 0x"..ToBase(Base64ToNumber[str:sub(i, i)], 16).." too large")
		end
		this:ResetPtr()
	end
	function this:ToBase64()
		local strtab = {}
		local accum = 0
		local pow = 0
		for i = 1, math.ceil((#mBitBuffer) / 6)*6 do
			accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
			pow = pow + 1
			if pow >= 6 then
				table.insert(strtab, NumberToBase64[accum])
				accum = 0
				pow = 0
			end
		end
		return table.concat(strtab)
	end
	
	-- Dump
	function this:Dump()
		local str = ""
		local str2 = ""
		local accum = 0
		local pow = 0
		for i = 1, math.ceil((#mBitBuffer) / 8)*8 do
			str2 = str2..(mBitBuffer[i] or 0)
			accum = accum + PowerOfTwo[pow]*(mBitBuffer[i] or 0)
			--print(pow..": +"..PowerOfTwo[pow].."*["..(mBitBuffer[i] or 0).."] -> "..accum)
			pow = pow + 1
			if pow >= 8 then
				str2 = str2.." "
				str = str.."0x"..ToBase(accum, 16).." "
				accum = 0
				pow = 0
			end
		end
		print("Bytes:", str)
		print("Bits:", str2)
	end
	
	-- Read / Write a bit
	local function writeBit(v)
		mBitPtr = mBitPtr + 1
		mBitBuffer[mBitPtr] = v
	end
	local function readBit(v)
		mBitPtr = mBitPtr + 1
		return mBitBuffer[mBitPtr]
	end
	
	function this:PrintPtr()
		print(mBitPtr.." / "..#mBitBuffer)
	end
	
	-- Read / Write an unsigned number
	function this:WriteUnsigned(w, value, printoff)
		local inValue = value
		assert(w, "Bad arguments to BitBuffer::WriteUnsigned (Missing BitWidth)")
		assert(value, "Bad arguments to BitBuffer::WriteUnsigned (Missing Value)")
		assert(value >= 0, "Negative value to BitBuffer::WriteUnsigned")
		assert(math.floor(value) == value, "Non-integer value to BitBuffer::WriteUnsigned")
		if mDebug and not printoff then
			print("WriteUnsigned["..w.."]:", value)
		end
		-- Store LSB first
		for i = 1, w do
			writeBit(value % 2)
			value = math.floor(value / 2)
		end
		assert(value == 0, "Value "..tostring(inValue).." is wider than "..w.." bits by "..value)
	end 
	function this:ReadUnsigned(w, printoff)
		local value = 0
		for i = 1, w do
			local r = readBit()
--			print(r, PowerOfTwo[i-1])
			value = value + r * PowerOfTwo[i-1]
		end
		if mDebug and not printoff then
			print("ReadUnsigned["..w.."]:", value)
		end
		return value
	end
	
	-- Read / Write a signed number
	function this:WriteSigned(w, value)
		assert(w and value, "Bad arguments to BitBuffer::WriteSigned (Did you forget a bitWidth?)")
		assert(math.floor(value) == value, "Non-integer value to BitBuffer::WriteSigned")
		if mDebug then
			print("WriteSigned["..w.."]:", value)
		end
		-- Write sign
		if value < 0 then
			writeBit(1)
			value = -value
		else
			writeBit(0)
		end
		-- Write value
		this:WriteUnsigned(w-1, value, true)
	end
	function this:ReadSigned(w)
		-- Read sign
		local sign = (-1)^readBit()
		-- Read value
		local value = this:ReadUnsigned(w-1, true)
		if mDebug then
			print("ReadSigned["..w.."]:", sign*value)
		end
		return sign*value
	end
	
	-- Read / Write a string. May contain embedded nulls (string.char(0))
	function this:WriteString(s)
		-- First check if it's a 7 or 8 bit width of string
		local bitWidth = 7
		for i = 1, #s do
			if s:sub(i, i):byte() > 127 then
				bitWidth = 8
				break
			end
		end
		
		-- Write the bit width flag
		if bitWidth == 7 then
			this:WriteBool(false)
		else
			this:WriteBool(true) -- wide chars
		end
	
		-- Now write out the string, terminated with "0x10, 0b0"
		-- 0x10 is encoded as "0x10, 0b1"
		for i = 1, #s do
			local ch = s:sub(i, i):byte()
			if ch == 0x10 then
				this:WriteUnsigned(bitWidth, 0x10)
				this:WriteBool(true)
			else
				this:WriteUnsigned(bitWidth, ch)
			end
		end
		
		-- Write terminator
		this:WriteUnsigned(bitWidth, 0x10)
		this:WriteBool(false)
	end
	function this:ReadString()
		-- Get bit width
		local bitWidth;
		if this:ReadBool() then
			bitWidth = 8
		else
			bitWidth = 7
		end
		
		-- Loop
		local str = ""
		while true do
			local ch = this:ReadUnsigned(bitWidth)
			if ch == 0x10 then
				local flag = this:ReadBool()
				if flag then
					str = str..string.char(0x10)
				else
					break
				end
			else
				str = str..string.char(ch)
			end
		end
		return str
	end
	
	-- Read / Write a bool
	function this:WriteBool(v)
		if mDebug then
			print("WriteBool[1]:", v and "1" or "0")
		end
		if v then
			this:WriteUnsigned(1, 1, true)
		else
			this:WriteUnsigned(1, 0, true)
		end
	end
	function this:ReadBool()
		local v = (this:ReadUnsigned(1, true) == 1)
		if mDebug then
			print("ReadBool[1]:", v and "1" or "0")
		end
		return v
	end
	
	-- Read / Write a floating point number with |wfrac| fraction part
	-- bits, |wexp| exponent part bits, and one sign bit.
	function this:WriteFloat(wfrac, wexp, f)
		assert(wfrac and wexp and f)
		
		-- Sign
		local sign = 1
		if f < 0 then
			f = -f
			sign = -1
		end
		
		-- Decompose
		local mantissa, exponent = math.frexp(f)
		if exponent == 0 and mantissa == 0 then
			this:WriteUnsigned(wfrac + wexp + 1, 0)
			return
		elseif f == 0.5 then
			exponent = -1
			mantissa = PowerOfTwo[wfrac]-1
		else
			mantissa = ((mantissa - 0.5)/0.5 * PowerOfTwo[wfrac])
		end
		
		-- Write sign
		if sign == -1 then
			this:WriteBool(true)
		else
			this:WriteBool(false)
		end
		
		-- Write mantissa
		mantissa = math.floor(mantissa + 0.5) -- Not really correct, should round up/down based on the parity of |wexp|
		this:WriteUnsigned(wfrac, mantissa)
		
		-- Write exponent
		local maxExp = PowerOfTwo[wexp-1]-1
		if exponent > maxExp then
			exponent = maxExp
		end
		if exponent < -maxExp then
			exponent = -maxExp
		end
		this:WriteSigned(wexp, exponent)	
	end
	function this:ReadFloat(wfrac, wexp)
		assert(wfrac and wexp)
		
		-- Read sign
		local sign = 1
		if this:ReadBool() then
			sign = -1
		end
		
		-- Read mantissa
		local mantissa = this:ReadUnsigned(wfrac)
		
		-- Read exponent
		local exponent = this:ReadSigned(wexp)
		if exponent == 0 and mantissa == 0 then
			return 0
		elseif exponent == -1 and mantissa == PowerOfTwo[wfrac]-1 then
			return 0.5
		end
		
		-- Convert mantissa
		mantissa = mantissa / PowerOfTwo[wfrac] * 0.5 + 0.5
		
		-- Output
		return sign * math.ldexp(mantissa, exponent)
	end
	
	-- Read / Write single precision floating point
	function this:WriteFloat32(f)
		this:WriteFloat(23, 8, f)
	end
	function this:ReadFloat32()
		return this:ReadFloat(23, 8)
	end
	
	-- Read / Write double precision floating point
	function this:WriteFloat64(f)
		this:WriteFloat(52, 11, f)
	end
	function this:ReadFloat64()
		return this:ReadFloat(52, 11)
	end
	
	-- Read / Write a BrickColor
	function this:WriteBrickColor(b)
		local pnum = BrickColorToNumber[b.Number]
		if not pnum then
			if not DISABLE_WARNINGS then
				warn("Attempt to serialize non-pallete BrickColor `"..tostring(b).."` (#"..b.Number.."), using Light Stone Grey instead.")
			end
			pnum = BrickColorToNumber[BrickColor.new(1032).Number]
		end
		this:WriteUnsigned(6, pnum)
	end
	function this:ReadBrickColor()
		return NumberToBrickColor[this:ReadUnsigned(6)]
	end
	
	-- Read / Write a rotation as a 64bit value.
	local function round(n)
		return math.floor(n + 0.5)
	end
	function this:WriteRotation(cf)
		local lookVector = cf.lookVector
		local azumith = math.atan2(-lookVector.X, -lookVector.Z)
		local ybase = (lookVector.X^2 + lookVector.Z^2)^0.5
		local elevation = math.atan2(lookVector.Y, ybase)
		local withoutRoll = CFrame.new(cf.p) * CFrame.Angles(0, azumith, 0) * CFrame.Angles(elevation, 0, 0)
		local x, y, z = (withoutRoll:inverse()*cf):toEulerAnglesXYZ()
		local roll = z
		-- Atan2 -> in the range [-pi, pi] 
		azumith   = round((azumith   /  math.pi   ) * (2^21-1))
		roll      = round((roll      /  math.pi   ) * (2^20-1))
		elevation = round((elevation / (math.pi/2)) * (2^20-1))
		--
		this:WriteSigned(22, azumith)
		this:WriteSigned(21, roll)
		this:WriteSigned(21, elevation)
	end
	function this:ReadRotation()
		local azumith   = this:ReadSigned(22)
		local roll      = this:ReadSigned(21)
		local elevation = this:ReadSigned(21)
		--
		azumith   =  math.pi    * (azumith   / (2^21-1))
		roll      =  math.pi    * (roll      / (2^20-1))
		elevation = (math.pi/2) * (elevation / (2^20-1))
		--
		local rot = CFrame.Angles(0, azumith, 0)
		rot = rot * CFrame.Angles(elevation, 0, 0)
		rot = rot * CFrame.Angles(0, 0, roll)
		--
		return rot
	end
	
	-- Read / Write a CFrame
	function this:WriteCFrame(cframe)
		local p = cframe.p
		this:WriteFloat32(p.X)
		this:WriteFloat32(p.Y)
		this:WriteFloat32(p.Z)
		this:WriteRotation(cframe)
	end
	function this:ReadCFrame()
		return CFrame.new(this:ReadFloat32(), this:ReadFloat32(), this:ReadFloat32()) * this:ReadRotation()
	end
	
	-- Read / Write a Color3 (by bgc :>)
	local c = {"r", "g", "b"}
	
	function this:WriteColor3(color)
		for i, v in pairs(c) do
			this:WriteUnsigned(8, math.floor(color[v] * 255 + 0.5))
		end
	end
	function this:ReadColor3()
		local a = {}
		
		for i, v in pairs(c) do
			table.insert(a, this:ReadUnsigned(8))
		end
		
		return Color3.fromRGB(unpack(a))
	end
	return this
end

function BitBuffer.SetBit(str, bitPos, v)
	local i = math.ceil(bitPos/6)
	local len = str:len()
	if len < i then
		str = str .. string.rep(NumberToBase64[0], i-len)
	end
	bitPos = (bitPos-1)%6+1
	local ch = Base64ToNumber[str:sub(i, i)]
	local accum = 0
	local pow = 0
	for b = 1, 6 do
		local bit = ch % 2
		if b == bitPos then
			if v == 0 or not v then
				bit = 0
			else
				bit = 1
			end
		end
		accum = accum + PowerOfTwo[pow]*bit
		pow = pow + 1
		ch = math.floor(ch / 2)
	end
	return str:sub(1, i-1) .. NumberToBase64[accum] .. str:sub(i+1)
end

function BitBuffer.GetBit(str, bitPos)
	if bitPos > str:len()*6 then return false end
	local i = math.ceil(bitPos/6)
	local ch = Base64ToNumber[str:sub(i, i)]
	bitPos = (bitPos-1)%6
	ch = math.floor(ch / PowerOfTwo[bitPos])
	return ch%2 == 1
end


return BitBuffer
-- 2022-01-01T17:32:56

-- 2022-01-01T11:19:29

-- 2022-01-01T22:41:34

-- 2022-01-03T17:44:27

-- 2022-01-04T19:14:15

-- 2022-01-04T20:28:35

-- 2022-01-05T10:53:39

-- 2022-01-08T13:35:07

-- 2022-01-10T21:58:23

-- 2022-01-11T19:57:49

-- 2022-01-11T22:21:52

-- 2022-01-14T10:47:08

-- 2022-01-14T21:39:43

-- 2022-01-14T10:42:24

-- 2022-01-16T22:20:06

-- 2022-01-17T17:45:27

-- 2022-01-18T16:27:27

-- 2022-01-18T20:20:44

-- 2022-01-20T11:29:54

-- 2022-01-23T09:03:49

-- 2022-01-24T13:03:50

-- 2022-01-26T15:44:58

-- 2022-01-28T15:55:37

-- 2022-01-29T17:05:40

-- 2022-01-30T14:36:43

-- 2022-01-31T20:49:37

-- 2022-02-01T12:48:45

-- 2022-02-01T20:15:53

-- 2022-02-02T17:14:13

-- 2022-02-02T21:01:48

-- 2022-02-05T15:28:13

-- 2022-02-07T16:56:22

-- 2022-02-09T22:21:19

-- 2022-02-10T12:43:30

-- 2022-02-10T20:40:24

-- 2022-02-11T10:54:40

-- 2022-02-12T17:47:43

-- 2022-02-12T18:03:45

-- 2022-02-12T10:25:33

-- 2022-02-12T14:34:07

-- 2022-02-13T14:06:21

-- 2022-02-16T09:55:15

-- 2022-02-18T11:04:18

-- 2022-02-18T22:27:21

-- 2022-02-18T09:32:04

-- 2022-02-19T13:26:01

-- 2022-02-20T20:28:43

-- 2022-02-22T21:36:03

-- 2022-02-22T17:25:39

-- 2022-02-26T17:44:32

-- 2022-02-27T18:24:00

-- 2022-03-01T22:12:34

-- 2022-03-01T11:25:29

-- 2022-03-01T11:08:05

-- 2022-03-03T17:45:06

-- 2022-03-03T12:20:38

-- 2022-03-05T14:39:30

-- 2022-03-06T15:53:20

-- 2022-03-07T16:38:48

-- 2022-03-09T17:43:23

-- 2022-03-12T19:15:25

-- 2022-03-12T12:22:02

-- 2022-03-13T16:24:19

-- 2022-03-13T20:21:19

-- 2022-03-13T22:05:30

-- 2022-03-14T13:40:19

-- 2022-03-16T11:33:17

-- 2022-03-16T20:20:04

-- 2022-03-18T10:13:56

-- 2022-03-20T22:39:20

-- 2022-03-20T16:17:00

-- 2022-03-24T21:53:25

-- 2022-03-25T18:52:50

-- 2022-03-28T11:02:04

-- 2022-03-28T18:53:03

-- 2022-03-29T22:14:44

-- 2022-03-29T20:46:27

-- 2022-03-30T19:12:27

-- 2022-03-30T14:24:05

-- 2022-03-30T17:55:07

-- 2022-04-01T12:55:40

-- 2022-04-01T18:48:47

-- 2022-04-02T15:03:20

-- 2022-04-06T20:59:48

-- 2022-04-07T20:25:08

-- 2022-04-07T16:43:46

-- 2022-04-09T15:27:33

-- 2022-04-14T13:23:22

-- 2022-04-16T18:22:34

-- 2022-04-17T10:46:57

-- 2022-04-17T09:03:04

-- 2022-04-19T09:24:03

-- 2022-04-21T13:15:49

-- 2022-04-22T12:56:52

-- 2022-04-23T12:16:24

-- 2022-04-25T10:45:58

-- 2022-04-26T21:09:24

-- 2022-04-26T16:17:31

-- 2022-04-26T09:31:19

-- 2022-04-27T11:08:04

-- 2022-04-28T14:12:52

-- 2022-04-29T13:09:16

-- 2022-05-01T13:51:16

-- 2022-05-02T11:29:47

-- 2022-05-03T12:48:17

-- 2022-05-03T16:59:35

-- 2022-05-05T11:38:28

-- 2022-05-05T13:50:49

-- 2022-05-07T12:29:29

-- 2022-05-07T22:46:40

-- 2022-05-07T15:19:42

-- 2022-05-09T15:01:53

-- 2022-05-10T15:58:41

-- 2022-05-11T15:17:34

-- 2022-05-13T22:52:53

-- 2022-05-13T13:11:56

-- 2022-05-13T20:00:35

-- 2022-05-14T11:06:28

-- 2022-05-14T21:58:34

-- 2022-05-14T15:46:27

-- 2022-05-16T18:59:15

-- 2022-05-17T17:40:50

-- 2022-05-17T13:40:39

-- 2022-05-19T18:11:51

-- 2022-05-19T12:07:39

-- 2022-05-21T15:48:41

-- 2022-05-26T19:04:35

-- 2022-05-26T14:26:02

-- 2022-05-27T17:01:14

-- 2022-05-30T10:26:56

-- 2022-06-01T19:22:43

-- 2022-06-01T17:51:47

-- 2022-06-02T19:00:58

-- 2022-06-03T16:34:34

-- 2022-06-08T22:31:46

-- 2022-06-08T21:31:57

-- 2022-06-09T15:10:45

-- 2022-06-09T11:25:35

-- 2022-06-12T12:38:14

-- 2022-06-12T16:10:16

-- 2022-06-14T09:50:44

-- 2022-06-14T14:28:21

-- 2022-06-15T14:19:51

-- 2022-06-16T09:13:14

-- 2022-06-22T15:45:37

-- 2022-06-23T12:17:42

-- 2022-06-24T20:22:42

-- 2022-06-25T20:25:50

-- 2022-06-29T11:27:33

-- 2022-06-29T10:36:35

-- 2022-06-30T12:13:19

-- 2022-06-30T10:26:00

-- 2022-06-30T15:48:07

-- 2022-07-01T18:14:53

-- 2022-07-01T16:21:20

-- 2022-07-03T19:09:20

-- 2022-07-05T12:21:03

-- 2022-07-06T10:54:35

-- 2022-07-06T18:59:22

-- 2022-07-07T18:36:06

-- 2022-07-07T14:52:02

-- 2022-07-09T13:38:48

-- 2022-07-10T16:31:21

-- 2022-07-12T11:09:01

-- 2022-07-14T19:54:45

-- 2022-07-14T16:06:56

-- 2022-07-16T17:05:02

-- 2022-07-18T20:11:12

-- 2022-07-19T12:43:37

-- 2022-07-20T12:09:44

-- 2022-07-21T22:55:20

-- 2022-07-21T20:36:02

-- 2022-07-21T17:49:05

-- 2022-07-22T18:12:45

-- 2022-07-22T14:55:58

-- 2022-07-23T11:51:01

-- 2022-07-23T22:51:07

-- 2022-07-24T22:29:33

-- 2022-07-25T10:59:39

-- 2022-07-25T17:55:16

-- 2022-07-26T14:23:02

-- 2022-07-26T13:35:51

-- 2022-07-27T10:46:49

-- 2022-07-27T16:49:45

-- 2022-07-28T15:53:38

-- 2022-07-30T19:06:16

-- 2022-07-31T11:55:36

-- 2022-08-01T18:45:12

-- 2022-08-02T16:49:01

-- 2022-08-07T13:25:31

-- 2022-08-09T09:10:39

-- 2022-08-10T12:03:40

-- 2022-08-12T16:25:08

-- 2022-08-14T12:06:58

-- 2022-08-16T14:25:55

-- 2022-08-16T17:14:59

-- 2022-08-18T18:49:40

-- 2022-08-21T15:22:55

-- 2022-08-21T18:17:47

-- 2022-08-23T19:45:43

-- 2022-08-23T19:40:47

-- 2022-08-23T18:07:48

-- 2022-08-24T10:13:52

-- 2022-08-26T22:56:01

-- 2022-08-26T16:12:48

-- 2022-08-27T10:57:53

-- 2022-08-28T11:31:46

-- 2022-08-28T16:24:40

-- 2022-08-29T18:03:10

-- 2022-08-29T15:44:11

-- 2022-08-30T12:17:56

-- 2022-08-30T17:10:39

-- 2022-08-31T15:40:33

-- 2022-08-31T17:41:49

-- 2022-09-03T19:33:22

-- 2022-09-03T18:32:18

-- 2022-09-03T09:33:06

-- 2022-09-04T18:54:16

-- 2022-09-04T21:53:55

-- 2022-09-05T21:38:31

-- 2022-09-05T16:58:45

-- 2022-09-06T18:36:00

-- 2022-09-08T13:16:19

-- 2022-09-08T11:43:08

-- 2022-09-09T11:39:08

-- 2022-09-09T16:26:23

-- 2022-09-09T20:13:24

-- 2022-09-10T19:13:14

-- 2022-09-12T17:57:23

-- 2022-09-14T16:59:51

-- 2022-09-15T15:37:57

-- 2022-09-17T11:51:22

-- 2022-09-21T11:56:37

-- 2022-09-21T17:53:26

-- 2022-09-21T11:02:15

-- 2022-09-21T13:06:53

-- 2022-09-24T11:51:18

-- 2022-09-24T11:14:54

-- 2022-09-25T22:05:05

-- 2022-09-26T20:37:46

-- 2022-09-28T19:25:11

-- 2022-09-29T19:35:56

-- 2022-09-29T22:39:38

-- 2022-10-01T14:46:54

-- 2022-10-02T12:37:37

-- 2022-10-02T22:27:46

-- 2022-10-03T12:34:36

-- 2022-10-05T20:24:39

-- 2022-10-05T18:10:59

-- 2022-10-06T20:18:47

-- 2022-10-07T20:20:36

-- 2022-10-09T17:09:16

-- 2022-10-14T21:34:16

-- 2022-10-16T14:57:41

-- 2022-10-16T18:32:08

-- 2022-10-18T16:30:35

-- 2022-10-21T18:01:39

-- 2022-10-21T17:36:02

-- 2022-10-21T16:59:25

-- 2022-10-22T14:49:31

-- 2022-10-24T11:41:26

-- 2022-10-24T10:34:17

-- 2022-10-27T11:11:49

-- 2022-10-30T21:13:58

-- 2022-10-31T20:12:07

-- 2022-10-31T22:50:07

-- 2022-11-01T19:20:34

-- 2022-11-01T18:58:15

-- 2022-11-02T13:22:04

-- 2022-11-02T18:02:43

-- 2022-11-02T09:12:55

-- 2022-11-02T15:18:52

-- 2022-11-05T16:47:24

-- 2022-11-05T12:18:16

-- 2022-11-06T13:31:30

-- 2022-11-07T19:55:05

-- 2022-11-07T10:37:30

-- 2022-11-10T18:56:23

-- 2022-11-15T11:04:10

-- 2022-11-17T15:22:01

-- 2022-11-18T10:49:51

-- 2022-11-18T12:08:10

-- 2022-11-22T22:17:48

-- 2022-11-22T17:30:14

-- 2022-11-23T13:41:07

-- 2022-11-27T17:55:56

-- 2022-11-27T22:25:41

-- 2022-11-27T17:02:39

-- 2022-11-30T10:47:02

-- 2022-12-03T21:19:18

-- 2022-12-03T09:44:01

-- 2022-12-06T17:49:01

-- 2022-12-07T22:49:41

-- 2022-12-10T19:12:14

-- 2022-12-10T10:53:28

-- 2022-12-10T21:03:17

-- 2022-12-13T15:44:17

-- 2022-12-13T16:08:37

-- 2022-12-13T18:45:22

-- 2022-12-14T20:44:38

-- 2022-12-18T15:33:02

-- 2022-12-25T19:01:35

-- 2022-12-25T18:14:53

-- 2022-12-25T15:54:03

-- 2022-12-27T20:22:26

-- 2022-12-30T18:01:29

-- 2022-12-30T14:19:45

-- 2022-12-30T15:56:39

-- 2022-12-31T22:12:18

-- 2022-12-31T13:50:09

-- 2022-12-31T17:11:35

-- 2023-01-01T11:22:40

-- 2023-01-01T18:59:27

-- 2023-01-03T19:43:21

-- 2023-01-03T20:02:31

-- 2023-01-07T22:45:05

-- 2023-01-11T21:31:35

-- 2023-01-11T09:09:54

-- 2023-01-13T22:32:31

-- 2023-01-13T12:52:41

-- 2023-01-14T19:30:31

-- 2023-01-14T10:59:39

-- 2023-01-15T17:45:32

-- 2023-01-17T15:08:53

-- 2023-01-18T14:52:06

-- 2023-01-18T19:22:12

-- 2023-01-28T11:03:33

-- 2023-01-29T20:16:21

-- 2023-01-31T17:25:05

-- 2023-01-31T22:21:27

-- 2023-02-06T09:19:16

-- 2023-02-06T18:46:30

-- 2023-02-11T16:19:18

-- 2023-02-12T16:54:48

-- 2023-02-13T10:04:55

-- 2023-02-19T10:20:45

-- 2023-02-19T20:21:47

-- 2023-02-20T19:16:35

-- 2023-02-20T13:06:48

-- 2023-02-23T14:55:34

-- 2023-02-26T15:24:25

-- 2023-02-27T09:53:34

-- 2023-02-27T16:13:58

-- 2023-03-01T14:57:56

-- 2023-03-01T14:55:51

-- 2023-03-02T18:48:08

-- 2023-03-05T15:54:05

-- 2023-03-06T22:54:04

-- 2023-03-09T22:04:07

-- 2023-03-09T17:36:39

-- 2023-03-10T22:55:58

-- 2023-03-10T11:02:14

-- 2023-03-10T18:30:38

-- 2023-03-15T18:31:21

-- 2023-03-15T20:14:18

-- 2023-03-16T14:34:22

-- 2023-03-21T22:32:50

-- 2023-03-21T14:12:57

-- 2023-03-21T22:44:59

-- 2023-03-24T17:42:29

-- 2023-03-24T17:01:24

-- 2023-03-24T17:49:22

-- 2023-03-25T20:48:40

-- 2023-03-29T18:08:22

-- 2023-03-29T15:47:10

-- 2023-03-31T14:49:17

-- 2023-04-02T10:46:08

-- 2023-04-02T13:12:52

-- 2023-04-03T15:07:24

-- 2023-04-04T18:47:38

-- 2023-04-04T17:58:28

-- 2023-04-04T13:16:51

-- 2023-04-05T21:52:25

-- 2023-04-08T13:21:25

-- 2023-04-08T15:45:11

-- 2023-04-10T15:13:30

-- 2023-04-10T21:17:34

-- 2023-04-10T22:55:22

-- 2023-04-13T11:16:03

-- 2023-04-14T13:25:26

-- 2023-04-14T22:18:55

-- 2023-04-18T10:00:53

-- 2023-04-18T13:10:04

-- 2023-04-22T18:34:48

-- 2023-04-24T16:06:16

-- 2023-04-25T09:11:24

-- 2023-04-25T10:09:43

-- 2023-05-02T19:45:59

-- 2023-05-05T20:33:04

-- 2023-05-08T11:51:20

-- 2023-05-08T13:21:13

-- 2023-05-08T19:32:31

-- 2023-05-08T20:07:43

-- 2023-05-10T14:01:02

-- 2023-05-11T17:15:20

-- 2023-05-13T12:18:56

-- 2023-05-13T10:15:10

-- 2023-05-13T13:22:47

-- 2023-05-22T18:56:20

-- 2023-05-22T13:32:12

-- 2023-05-27T20:37:40

-- 2023-05-27T20:03:12

-- 2023-05-27T21:56:23

-- 2023-05-28T11:53:19

-- 2023-05-31T11:30:21

-- 2023-06-04T19:02:13

-- 2023-06-07T16:44:02

-- 2023-06-07T17:00:57

-- 2023-06-08T13:22:17

-- 2023-06-09T10:57:49

-- 2023-06-13T11:25:53

-- 2023-06-13T22:30:19

-- 2023-06-13T10:34:18

-- 2023-06-15T21:22:27

-- 2023-06-16T13:18:22

-- 2023-06-17T10:51:01

-- 2023-06-19T22:26:42

-- 2023-06-21T15:45:44

-- 2023-06-22T12:45:02

-- 2023-06-22T16:33:02

-- 2023-06-29T13:00:26

-- 2023-06-29T21:36:32

-- 2023-06-29T10:17:20

-- 2023-06-29T11:13:05

-- 2023-06-29T19:47:34

-- 2023-07-02T21:33:19

-- 2023-07-02T21:37:19

-- 2023-07-05T17:01:32

-- 2023-07-07T10:48:59

-- 2023-07-09T12:57:55

-- 2023-07-09T20:45:07

-- 2023-07-12T21:25:29

-- 2023-07-12T10:16:00

-- 2023-07-15T17:05:37

-- 2023-07-15T13:53:06

-- 2023-07-17T11:45:12

-- 2023-07-21T10:34:19

-- 2023-07-21T14:25:29

-- 2023-07-26T14:23:54

-- 2023-07-26T15:55:09

-- 2023-07-26T13:41:37

-- 2023-07-27T11:40:19

-- 2023-07-31T20:15:56

-- 2023-07-31T15:40:07

-- 2023-08-01T15:09:18

-- 2023-08-02T12:01:50

-- 2023-08-04T15:56:43

-- 2023-08-04T12:01:03

-- 2023-08-16T10:14:54

-- 2023-08-19T10:11:36

-- 2023-08-19T13:16:30
