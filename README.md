fibaroHue
=========

Control Philips Hue from a Fibaro HomeCenter 2

Installing
==========

Create a user on the Philips Hue bridge. This is required to remote control the lights.
See http://developers.meethue.com/gettingstarted.html. Create a user named 'domoplusplus'

On the Home Center create a global variable named 'Philips_Hue_IP' and set its value to 
the IP address of the Philips Hue bridge.

Create a virtual device, and add the following elements;
1 line with 2 buttons
4 sliders

Button1; 

- label = `On`
- ID = `buttonOn`

Button2;

- label = `Off`
- ID = `buttonOff`

Slider1;

- label = `Level`
- ID = `sliderLevel`

Slider2;

- label = `Red`
- ID = `sliderRed`

Slider3;

- label = `Green`
- ID = `sliderGreen`

Slider4;

- label = `Blue`
- ID = `sliderBlue`

Now paste the code files into the 6 buttons/sliders. The `off.lua` file goes into 
the `buttonOff` element. All other elements get the `slider.lua` (so also for 
`buttonOn`).

When pasting the code, make sure to adapt the first line; the ID number of the 
Hue light to control.

Save the virtual device and try it.

