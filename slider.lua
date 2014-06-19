local HueDevice = 1    -- enter Philips Hue Light ID

-- Nothing to customize below
-- This code goes into the ON button and the 4 sliders

local HueUser = 'domoplusplus'
local HueAddress = fibaro:getGlobalValue('Philips_Hue_IP')
local HuePort = 80
local HueIcon = fibaro:getGlobalValue('Philips_Hue_IconID')

local myDeviceID = fibaro:getSelfId()
local R = fibaro:get(myDeviceID, "ui.sliderRed.value")
local G = fibaro:get(myDeviceID, "ui.sliderGreen.value")
local B = fibaro:get(myDeviceID, "ui.sliderBlue.value")
local L = fibaro:get(myDeviceID, "ui.sliderLevel.value")

--[[
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 100] and
 * returns h, s, and l in the set [0, 1].
 Function modified from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
]]
function rgbToHsl(r, g, b)
  r, g, b = r / 100, g / 100, b / 100

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    if l > 0.5 then 
      s = d / (2 - max - min) 
    else 
      s = d / (max + min) 
    end
    if max == r then
      h = (g - b) / d
      if g < b then 
        h = h + 6 
      end
    elseif max == g then 
      h = (b - r) / d + 2
    elseif max == b then 
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l
end


local hue, sat, bri
hue, sat = rgbToHsl(R,G,B)
hue = math.floor(hue * 65535)
sat = math.floor(sat * 255)
bri = math.floor(L * 2.55)

local conn = Net.FHttp(HueAddress,HuePort) 
conn:PUT('/api/'..HueUser..'/lights/'..HueDevice..'/state', '{"on":true, "bri":'..bri..' , "hue":'..hue..' , "sat":'..sat..' }')

-- now set the icon and store icon state
HueIcon = HueIcon + math.floor(L*0.99/10) + 1  -- calculate IconID
fibaro:call(myDeviceID, "setProperty", "currentIcon", HueIcon)
fibaro:setGlobal('Philips_Hue_'..tostring(HueDevice), HueIcon)
