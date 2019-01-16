local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")

-- Requires 'Utils' for roundDown and decToHex
--local Utils = require("Utils")


local ColourUtils = {}
ColourUtils.__index = ColourUtils

function ColourUtils.init(colours)
    local colour = {}
    setmetatable(colour, ColourUtils)
    -- Apply default green to red if not provided
    colour.all = colours or {"#42C41B", "#FFFF00", "#FF8000", "#FF0000"}
    colour.size = Utils.tableLen(colour.all)
    colour.base = Utils.roundDown(100/(colour.size - 1), 1)
    colour.current = colour.size
    colour.last = colour.size
    return colour
end

-- blend two given colours
function ColourUtils.blend(colour_1, colour_2, percentage)
    local function mix(primary_1, primary_2)
        return Utils.roundDown(tonumber(primary_1, 16)*(100-percentage)/100.0 + tonumber(primary_2, 16)*(percentage)/100.0, 1)
    end
    local r1, g1, b1 = string.match(colour_1, "#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
    local r2, g2, b2 = string.match(colour_2, "#([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
    return "#" .. Utils.decToHex(mix(r1, r2)) .. Utils.decToHex(mix(g1, g2)) .. Utils.decToHex(mix(b1, b2))
end

-- Select colour based on percentage
function ColourUtils.update(self, percentage)
    -- Scale percentage relative to each colour pair
    scaled_percentage = Utils.roundDown(((percentage % self.base) / (self.base) ) * 100, 1)

    -- Because of the modulo technique 100% scaled = 0
    if (scaled_percentage == 0) then
        scaled_percentage = 100
    end

    -- if 100% we have switched colour (get next colour pair)
    if (scaled_percentage == 100) then
        self.last = self.current
        self.current = (self.current-1 > 0) and self.current-1 or 1
    end

      -- Return hex code for blended colour pair
    return ColourUtils.blend(self.all[self.current], self.all[self.last], scaled_percentage)
end

return ColourUtils
