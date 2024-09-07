# CS-4590-Simulator
This simulator is intended to mimic a wearable auditory device which provides information about a caver’s environment. Caving is an “extreme sport” in which an individual explores the depths of a cave system, which may involve going through intense situations such as crawling through very tight spaces or climbing down large walls. This simulator has four modes: _Vitals_, _Distance_, _Crawling_, and _Climbing_.

## Modes
### Vitals
The vitals mode is intended to provide the user with important information about their status or environment which they should immediately be notified about. The mode has three variables that can be manipulated with sliders.

- **Heart Rate:** _(bpm)_ The heart rate of the user (threshold is above 120 bpm).
    - Simulates a hospital heart rate monitor sound and gives a verbal warning to calm the user’s breathing.
    - Manipulated via slider.
- **Rate of Water Flow:** _(m^3 / s)_ The rate of water flow inside the cave system (threshold is above 100 m^3 / s).
    - Plays a waterfall sound and manipulates a high pass filter on the sound, as well as giving a verbal warning about the water flow.
    - Manipulated via slider.
- **Body Temperature:** _(°F)_ The body temperature of the user (threshold is below 95°F).
    - Plays a wind sound and manipulates a gain on the sound, as well as giving a verbal warning about hypothermia risk to the user.
    - Manipulated via slider.

All scenarios manipulate the vitals mode via JSON data. Press the “Turn Off/On Vitals” button in order to turn off or on sound from the vitals mode; this will allow you to listen to other modes even when vitals data are past their warning thresholds. The vitals mode takes priority over all other modes; within the vitals mode, the heart rate takes highest precedent, then the rate of water flow, and finally the user’s body temperature.

### Distance
The distance mode is intended to provide the user with information about their distance between themselves and a selected waypoint. The mode has four different variables that can be manipulated with sliders.

- **Distance:** _(m)_ The distance between the user and the selected waypoint.
    - Plays a fundamental wave sound, which has a higher frequency with a higher distance.
    - Manipulated via slider.
- **Euler Angle (X):** _(°)_ The “x” component of the Euler angle between the user and the selected waypoint.
    - Plays a harmonic of the fundamental wave sound, which has a gain with a larger angle value.
    - Manipulated via slider.
- **Euler Angle (Y):** _(°)_ The “y” component of the Euler angle between the user and the selected waypoint.
    - Plays a harmonic of the fundamental wave sound, which has a gain with a larger angle value.
    - Manipulated via slider.
- **Euler Angle (Z):** _(°)_ The “z” component of the Euler angle between the user and the selected waypoint.
    - Plays a harmonic of the fundamental wave sound, which has a gain with a larger angle value.
    - Manipulated via slider.

The mode has five possible waypoints or people to select using a button bar at the bottom; each waypoint stores separate values for the four aforementioned variables. The “distance” scenario will manipulate the distance mode via JSON data. The user can select the distance mode via the “Distance” button in mode controls.

### Crawling
The crawling mode is intended to provide the user with information about their status and environment while crawling through a tight space. The mode has three different variables that can be manipulated with sliders.

- **Squeeze Space:** _(m^3)_ The volume of empty space surrounding the user.
    - Creates a reverb on the sound that increases with a larger amount of space.
    - Manipulated via slider.
- **Pressure:** _(mmHg)_ The highest amount of pressure the body is current feeling, to give information about whether a part of the user is lodged between a tight rock crevice.
    - Increases the gain of the harmonics of a square wave with an increase in the pressure.
    - Manipulated via slider.
- **Narrowness:** How narrow the cave passage will become in the future, with a 0 meaning the same amount of narrowness or wider, and a 1 meaning an entirely closed off passage in front of the user.
    - Increases the fundamental frequency of a square wave with an increase in the narrowness.
    - Manipulated via slider.

The “crawling” scenario will manipulate the crawling mode via JSON data. The user can select the crawling mode via the “Crawling” button in mode controls.

### Climbing
The climbing mode is intended to provide the user with information about their status and environment while climbing up or down a drop off in the cave system. The mode has five different variables that can be manipulated with different UI controls.

- **Max Elevation:** _(m)_ The total height of the drop off.
    - Manipulated via slider.
- **Elevation:** _(m)_ The current elevation of the user from the top of the drop off, compared to the total height of the drop off.
    - Increases the time between a sine wave which plays in beats with an increase in elevation.
    - Manipulated via slider.
- **Rigidity:** _(Pa)_ The rigidity of the surface that the user is holding on to, with a lower value meaning a less rigid and more breakable surface.
    - Increases the reverb on the sound with an increase in rigidity.
    - Manipulated via slider.
- **Wetness:** The slipperiness of the surface that the user is holding on to due to water on the surface.
    - Increases the fundamental frequency of the sine wave which is beating with an increase in wetness.
    - Manipulated via slider.
- **Contact Points:** The number of limbs that the user is holding on to the surface of the cave wall with, in order to comply with the “three points of contact rule.”
    - Plays a verbal warning if less than 3 limbs are selected.
    - Manipulated via button bar.

The “climbing” scenario will manipulate the climbing mode via JSON data. The user can
select the climbing mode via the “Climbing” button in mode controls.

## Functionality
The top left corner of the simulator displays general controls as well as vitals mode controls. Vitals mode is always active no matter which mode is selected, although the vitals mode can be turned off via a “Turn Off/On Vitals” button, which will not play any sounds from the vitals mode even if any variables are above their threshold. To select the other three modes, there are buttons which allow you to select the desired mode - selecting a mode will cause a faint image to appear behind that mode’s controls, as well as the sound of that mode turning on. In addition to changing the output of the simulator via UI controls, you can also play preset scenarios for each mode which demonstrate all modes in a realistic scenario. These scenarios are created from JSON data stored in the “data” folder, with each scenario having its own JSON file. _**NOTE:** Instead of marking the values of each variable at every time step, the JSON functionality for this simulator allows the simulator to interpolate between defined time steps in the JSON file - therefore, while there may be a relatively sparse amount of data in the JSON file itself, the simulator is able to interpolate values in between each time step and provide continuous sonification of the data as it changes linearly._ To select a scenario, press the scenario buttons, each corresponding to their own mode - changing the scenario will automatically set the simulator to that mode. Press the “Play/Pause” button to play or pause the currently selected scenario; while the simulator is playing a scenario, a green box will display around the mode which is selected. Press the “Replay” button to reset the scenario to the beginning. The “distance” scenario demonstrates a user turning their head to find a waypoint, and then moving a certain distance towards/away from that waypoint. The “crawling” scenario represents a user crawling through a tighter and tighter passageway, at some point getting stuck, but continuing on. The “climbing” scenario represents a user climbing down a drop off, slipping from the wall, but managing to grab back on and continue climbing down.
