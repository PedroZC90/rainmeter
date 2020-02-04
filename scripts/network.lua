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

    text = format("Down: %5s | Up: %5s", ShortValue(download, percision), ShortValue(upload, percision))

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

ShortValue = function(number, precision)
    -- assert(type(number) == "number", "Round expects a number as argument.")
    local value, unit = number, "B/s"
    if (number > 1E9) then
        value = Round(number / GIGABYTES_BYNARY, precision)
        unit = "GB/s"
    elseif (number > 1E6) then
        value = Round(number / MEGABYTES_BYNARY, precision)
        unit = "MB/s"
    elseif (number > 1E3) then
        value = Round(number / KILOBYTES_BYNARY, precision)
        unit = "KB/s"
    end
    return format("%5.2f %s", value, unit)
end
