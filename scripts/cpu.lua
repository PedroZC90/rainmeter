local format = string.format
local floor, ceil = math.floor, math.ceil

local NUMBER_OF_PROCESSORS = tonumber(os.getenv("NUMBER_OF_PROCESSORS"))

function Initialize()

    colors = {}
    colors.default = SKIN:GetVariable("ColorDefault")
    colors.alert = SKIN:GetVariable("ColorAlert")
    colors.warn = SKIN:GetVariable("ColorWarn")

    precision = tonumber(SKIN:GetVariable("Precision"))

    measureName = SELF:GetOption("MeasureName")
    meterName = SELF:GetOption("MeterName")
    
    -- processor 0 is equal to average cpu usage
    cpu = SKIN:GetMeasure(measureName)
    
    -- measure of cores 0 to n-1, where n = NUMBER_OF_PROCESSORS
    cores = {}
    for i = 0, NUMBER_OF_PROCESSORS do
        cores[i] = SKIN:GetMeasure(measureName .. (i - 1))
    end

end

function Update()

    -- text = ""
    -- for i = 0, NUMBER_OF_PROCESSORS do
    --     text = text .. format("%s: %2.2f\n", measureName .. i, Round(cores[i]:GetValue(), 2))
    -- end
    usage = cpu:GetValue()

    SKIN:Bang("!SetOption", meterName, "Text", format("CPU: %s%%", Round(usage, precision)))

    if (usage >= 75.0) then
        SKIN:Bang("!SetOption", meterName, "FontColor", colors.alert)
    elseif (usage >= 50.0) then
        SKIN:Bang("!SetOption", meterName, "FontColor", colors.warn)
    else
        SKIN:Bang("!SetOption", meterName, "FontColor", colors.default)
    end
        
end

Round = function(number, decimals)
    assert(type(number) == "number", "Round expects a number as argument.")
    local mult = 10^(decimals or 0)
    if (number >= 0) then
        return floor(number * mult + 0.5) / mult
    end
    return ceil(number * mult - 0.5) / mult
end
