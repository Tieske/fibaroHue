local HueDevice = 1    -- enter Philips Hue Light ID

-- Nothing to customize below
-- This code goes into the OFF button

local HueUser = 'domoplusplus'
local HueAddress = fibaro:getGlobalValue('Philips_Hue_IP')
local HuePort = 80
local HueIcon = fibaro:getGlobalValue('Philips_Hue_IconID')
local myDeviceID = fibaro:getSelfId()


local conn = Net.FHttp(HueAddress,HuePort) 
conn:PUT('/api/'..HueUser..'/lights/'..HueDevice..'/state', '{"on":false}')

-- now set the off icon and store icon state
fibaro:call(myDeviceID, "setProperty", "currentIcon", HueIcon)
fibaro:setGlobal('Philips_Hue_'..tostring(HueDevice), HueIcon)
