
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local Utils = {}

-- return files and folders in a given directory
function Utils.scanDir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen([[ls -a "]] ..directory..[[']])
    for item in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

-- Convert decimal value to hex
function Utils.decToHex(value)
    if type(value) == "string" then
        value = tonumber(value)
    end
    local hexValue = string.format("%X", Utils.roundDown(tonumber(value),1))
    if value < 16 then
        return "0" .. hexValue
    else
        return "" .. hexValue
    end
end

-- Round a given value to nearest multiple of base
function Utils.roundDown(value, base)
    if type(value) == "string" then
        value = tonumber(value)
    end
    return value - (value % base)
end

-- Get size of a given table
function Utils.tableLen(table)
    local count = 0
    for k, v in pairs(table) do
        count = count + 1
    end
    return count
end

-- Invert Table; key:value -> value:key
function Utils.tableInvert(table)
    local inv = {}
    for k, v in pairs(table) do
        inv[v] = k
    end
    return inv
end


return Utils
