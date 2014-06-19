fibaroHue
=========

Control Philips Hue from a Fibaro HomeCenter 2

Features;
 - Sets the Virtual Device icon according to the light status (full dimm range in icon)
 - Allows to set RGB and brightness values
 - Has 4 presets (can be updated in code)
 - Uses the Virtual Device main button to toggle powerstate
 - Has on/off buttons which can be called from scenes
 - DOES NOT: read current Light state and update fibaro UI, so it's one-way
 - Has no mainloop code, to minimize performance impact on the HC2 (hence not the current state reading)

Especially the current state being displayed by the icon and the main button 
used to toggle power is a very nice combination that makes it a pleasure to use.

License
=======
GPL, see the LICENSE file

Why this code
=============
This was an excercise to see how well the Fibaro HomeCenter can be customized, the main goal here being
managebility of a larger installed base of HC2's with many Hue lights. When managing such a base, I need
the simplest setup, with least manual interactions. So preferably, import a device, and nothing else.

Unfortunately there where quite some obstacles and I'm not really satified with the results.

Obstacles;
----------

- the mainloop and the individual buttons do not execute in the same Lua environment (see the Lua `getfenv` 
and `setfenv` functions). If they would, temporary state could simply be stored in a Lua variable in this
environment. Now it can't and I have to create a new global in the globals panel for each individual Hue
light added to the system. This is cumbersome, errorprone, and completely unnecessary. 

- similar to the previous one; Currently the ID of the Hue light has to be set in each of the 11 Lua code 
blocks of the virtual device. When sharing environments, it could have been 1 code block. Adding a new device
could have been 2 steps; 1 import device, 2 update one line of code with the ID. As mentioned; cumbersome,
errorprone and unnecessary.

- To work around the previous issues, I used the device icon, to determine the current state. That also 
failed because each time a UI element is clicked, the icon associated with that element is set for the 
device. Even if the UI element does not even have an icon set (it reverts to the blue box icon). See
this reported issue; http://bugzilla.fibaro.com/view.php?id=1545 . And this finally forced me to use
an extra global for each Hue light added.

- I wanted the user to be able to customize the 4 presets. Unfortunately the globals one can create in 
the HC interface only allow for numerical values. So I have no option other than to revert users who
want to modify the presets, to actively go and update the code in the code editor. Very dissapointing
(lucky for me the check is not so well implemented, so it does accept an IP address as a value though 
technically that is also not a numerical value)

- I have 4 presets, each with identical Lua code (easier to manage), I wanted to determine dynamically
which button was pressed, so I could dynamically fetch the preset values to set. Unfortunately the button 
name/id could not be dynamically retrieved. Hence, when updating the code, each individual block still has
to be updated manually to select the proper preset number  -->  more manual, errorprone handling.

Achievements
------------

- Managebility; IP address of Hue bridge set once, used by all lights added thereafter without any additional configuration
- Managebility; Upload the icon set once, used by all lights added thereafter without any additional configuration
- Usage; a toggle button to be used as main button, so it has a sensible and intuitive use
- Usage; icon indicates current light status, from http://forum.fibaro.com/viewtopic.php?t=3635
- Usage; RGB control


External resources included
===========================
Color conversion code modified from; https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
Icons found here; http://forum.fibaro.com/viewtopic.php?t=3635

Installing
==========

One time only;
--------------

- Create a user on the Philips Hue bridge. This is required to remote control the lights.
See http://developers.meethue.com/gettingstarted.html. Create a user named 'domoplusplus'

- On the Home Center create a global variable named 'Philips_Hue_IP' and set its value to 
the IP address of the Philips Hue bridge

- Open a Virtual Device icon panel, and upload all icons (in the exact order as they are 
numbered!!! this is important!)

- Find the ID of the first icon, in Google Chrome, right click the icon and select 'Inspect Element'
from the menu. This should open a window where the ID is a number somewhere from 1000 onwards, depending
on much custom icons you have uploaded

- On the Home Center create a global variable named 'Philips_Hue_IconID' and set its value to 
the ID of the icon found in the previous step

For each Hue bulb you want to add;
----------------------------------

- determine the Hue ID of the light you want to control (the ID used by the Hue bridge). Needed in the steps below.

- On the Home Center create a global variable named 'Philips_Hue_xx' (where xx is the Hue ID). The 
value is unimportant and will be automatically set later (it will get the ID of the last icon set).

- create a new virtual device from the `.vfib` file

- Open the device and in each Lua code block update the first line; `local HueDevice = xx` such that `xx` is
the Hue ID (IMPORTANT: repeat this for each Lua code block!)

- Save the device

Optional
--------

Because the icons for the device itself and each slider/button in the UI will probably be lost when importing 
the device, you might see the default icon for virtual devices (blue box) flashing, when using the UI. To 
mitigate this manually update the icons as follows;

- virtual device main icon: lightbulb off icon
- buttonOn: lightbulb 100% on icon
- buttonOff: lightbulb off icon
- all others: the 50% lightbulb icon
