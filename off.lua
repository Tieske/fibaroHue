local HueDevice = 1    -- enter Philips Hue Light ID
local HueUser = 'domoplusplus'
local HueAddress = fibaro:getGlobalValue('Philips_Hue_IP')
local HuePort = 80

local conn = Net.FHttp(HueAddress,HuePort) 
conn:PUT('/api/'..HueUser..'/lights/'..HueDevice..'/state', '{"on":false}')
