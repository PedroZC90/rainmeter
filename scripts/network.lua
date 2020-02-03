local format = string.format
local floor, ceil = math.floor, math.ceil

local GIGABYTES_BYNARY = 1073741824 -- bytes
local MEGABYTES_BYNARY = 1048576 -- bytes
local KILOBYTES_BYNARY = 1024 -- bytes

function Initialize()

    -- variables
    percision = SKIN:GetVariable("Precision")

    -- measures
    networkIn = SKIN:GetMeasure("MeasureNetIn")
    networkOut = SKIN:GetMeasure("MeasureNetOut")

    -- meters
    meterName = SELF:GetOption("MeterName")
    meterNetwork = SKIN:GetMeter(meterName)

end

function Update()

    download = networkIn:GetValue() 
    upload = networkOut:GetValue()

    text = format("Down: %s | Up: %s", ShortValue(download, percision), ShortValue(upload, percision))

    SKIN:Bang("!SetOption", meterNetwork:GetName(), "Text", text)

end

Round = function(number, decimals)
    if (precision == false) then return number end
    assert(type(number) == "number", "Round expects a number as argument.")
    local mult = 10^(decimals or 0)
    if (number >= 0) then
        return floor(number * mult + 0.5) / mult
    end
    return ceil(number * mult - 0.5) / mult
end

ShortValue = function(value, precision)
    -- assert(type(number) == "number", "Round expects a number as argument.")
    if (value > 1E9) then
        return Round(value / GIGABYTES_BYNARY, precision) .. " GB/s"
    elseif (value > 1E6) then
        return Round(value / MEGABYTES_BYNARY, precision) .. " MB/s"
    elseif (value > 1E3) then
        return Round(value / KILOBYTES_BYNARY, precision) .. " KB/s"
    end
    return Round(value, precision) .. " B/s"
end
