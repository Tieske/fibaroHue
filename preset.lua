local HueDevice = 1    -- enter Philips Hue Light ID

local preset = 1       -- the preset to use for this button  --> update to match the button (1 - 4) this code is in!!

local presets = {      -- customize the presets if you want, see the Philips api docs for the json notation
     '{ "bri":144, "hue":13088, "sat":212 }',    -- preset 1; Relax
     '{ "bri":240, "hue":15331, "sat":121 }',    -- preset 2; Reading
     '{ "bri":203, "hue":34495, "sat":232 }',    -- preset 3; Energy
     '{ "effect":"colorloop" }',                 -- preset 4; Colorloop
}

-- Nothing to customize below
-- This code goes into the 4 preset buttons (the 5th is the Tgl button)


local HuePreset = presets[preset]
local HueUser = 'domoplusplus'
local HueAddress = fibaro:getGlobalValue('Philips_Hue_IP')
local HuePort = 80
local HueIcon = fibaro:getGlobalValue('Philips_Hue_IconID')
local myDeviceID = fibaro:getSelfId()


local conn = Net.FHttp(HueAddress,HuePort) 
conn:PUT('/api/'..HueUser..'/lights/'..HueDevice..'/state', preset)

-- check the preset to update icons
local jsonTable = json.decode(HuePreset)
jsonTable.on = true   -- preset means always on
if jsonTable.bri then
   -- brightness is being set so update slider
   local bri = math.floor(tonumber(jsonTable.bri)/2.55)
   fibaro:call(myDeviceID, "setProperty", "ui.sliderLevel.value", tostring(bri))
end
-- RGB sliders will NOT be updated
fibaro:call(myDeviceID, "pressButton", "1")  -- 1 = On  --> will set proper icon and update globals

-- serialize updated table and transmit to Hue
HuePreset = json.encode(jsonTable)
local conn = Net.FHttp(HueAddress,HuePort) 
conn:PUT('/api/'..HueUser..'/lights/'..HueDevice..'/state', HuePreset)
