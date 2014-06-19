local HueDevice = 1    -- enter Philips Hue Light ID

-- Nothing to customize below
-- This code goes into the Tgl button, which is also the 'main' button (most right on the preset list)

local myDeviceID = fibaro:getSelfId()
local HueIcon = tonumber(fibaro:getGlobalValue('Philips_Hue_IconID')) or 0  -- get base icon == off icon
local icon = tonumber(fibaro:getGlobalValue('Philips_Hue_'..tostring(HueDevice))) or 0

if icon == HueIcon then
  fibaro:call(myDeviceID, "pressButton", "1")  -- 1 = On
else
  fibaro:call(myDeviceID, "pressButton", "2")  -- 2 = Off
end
