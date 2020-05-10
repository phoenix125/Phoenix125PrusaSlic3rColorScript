Phoenix125PrusaSlic3rColorScript - Comments out T Codes from G-code files.  Used for post-processing of G-codes for M3D Crane Quad.
- Latest version: Phoenix125PrusaSlic3rColorScript_v1.0 (2020-05-10)
- By Phoenix125 | http://www.Phoenix125.com | http://discord.gg/EU7pzPs | kim@kim125.com
- Thanks to NJallday for sharing his M3D Crane Quad PrusaSlic3r profile.  About 80% of the included config was based on his settings. 

Sections: (Use Search CTRL-F to quickly access) 

-----------------------------------------------------------------------------------------------------------------------
 FEATURES
----------
•	Free Open Source program.
•	Used for automatic post-processing of multiple extruder (color) G-codes for M3D Crane Quad.
•	Simple function: Comments out all T Codes from. gcode files.
•	Logs all changes into a log file.
•	Creates a backup of the original G-code.
•	Two modes:
	o	Command line for automatic post-script processing
	o	Executable for manually processing files.

-----------------------------------------------------------------------------------------------------------------------
 INSTRUCTIONS
--------------
1. Import attached Insert "Tool change G-code" (see below) into PrusaSlic3r: Printer Settings -> Custom G-code -> Tool change G-code

1.  Prepare PrusaSlic3r to add color changing codes by EITHER METHOD below:
	•	Import the included PrusaSlic3r_Config_Phoenix125_M3D_Quad.ini config file
	•	OR Use your existing profile and have PrusaSlic3r add the color changing codes
		o	Enter the following G-code into the Tool change G-code Custom G-code section of Printer Settings: Printer Settings -> Custom G-code -> Tool change G-code
{if next_extruder == 0}M567 P0 E1.00:0.00:0.00:0.00
{elsif next_extruder == 1}M567 P0 E0.00:1.00:0.00:0.00
{elsif next_extruder == 2}M567 P0 E0.00:0.00:1.00:0.00
{elsif next_extruder == 3}M567 P0 E0.00:0.00:0.00:1.00
{elsif next_extruder == 4}M567 P0 E0.50:0.50:0.00:0.00     ; Example of mixing
{elsif next_extruder == 5}M567 P0 E0.00:0.00:0.50:0.50     ; Example of mixing
{endif}
 
Adjust the extruder ratios (color blending) by adjusting the M567 P0 E[0]:[1]:[2]:[3] flow rate percentages in the code.
	•	Create as many virtual extruders as desired for your print by adding more “elseif next_extruder” lines
	•	Each “0.00” controls the flow rate of the corresponding extruder. 
		o	Ie. M567 P0 E1:1:1:1 would run all four extruders at full speed, extruding 4x as much filament
	•	In the included example, extruder 4 (a “virtual” extruder) will mix 50% each of Filaments 0 and 1 
	
2. Enter the file location for the included Phoenix125PrusaSilc3rColorScript.exe file:
	•	This will run the included program automatically after you export your G-code.
	•	PrusaSlic3r adds T codes for each color change. The M3D Quad does not accept these T codes.
	•	The Phoenix125PrusaSilc3rColorScript program simply comments out all T codes.
 
3. Import your STL, make any changes, and Export G-code
 
4. You’re done!  Your G-code file is ready to print!

-----------------------------------------------------------------------------------------------------------------------
 Links
-------
                     Download PrusaSlic3r:  https://www.prusa3d.com/drivers/
Download Phoenix125PrusaSlic3rColorScript:  http://www.phoenix125.com/share/PrusaSlic3r/Phoenix125PrusaSlic3rColorScript.zip
                       GitHub Source Code:  https://github.com/phoenix125/Phoenix125PrusaSlic3rColorScript
                        Developer website:  http://www.Phoenix125.com

-----------------------------------------------------------------------------------------------------------------------
 EXAMPLE CUSTOM G-CODES
------------------------
- Tool change G-code (see below) is required to insert M3D Crane Quad color changing codes

----- Start G-code ------
M140 S[first_layer_bed_temperature]    ; set bed temp
M190 S[first_layer_bed_temperature]    ; wait for bed temp
G28                                    ; home all axes
M104 S[first_layer_temperature]        ; set extruder temp
M109 S[first_layer_temperature]        ; wait for extruder temp
M567 P0 E0.85:0.05:0.05:0.05           ; set default to 85% extruder 0, 5% other three

----- End G-code -----
M104 S0                                ; turn off extruder temperature
M140 S0                                ; turn off heatbed
M106 S0                                ; turn off fan
{if layer_z < max_print_height}G1 Z{z_offset+min(layer_z+10, max_print_height)}{endif}    ; Move print head up
G1 X0 Y230 F1000                       ; prepare for part removal
M84                                    ; disable motors

----- Tool change G-code -----
{if next_extruder == 0}M567 P0 E1.00:0.00:0.00:0.00
{elsif next_extruder == 1}M567 P0 E0.00:1.00:0.00:0.00
{elsif next_extruder == 2}M567 P0 E0.00:0.00:1.00:0.00
{elsif next_extruder == 3}M567 P0 E0.00:0.00:0.00:1.00
{elsif next_extruder == 4}M567 P0 E0.50:0.50:0.00:0.00     ; Example of mixing
{elsif next_extruder == 5}M567 P0 E0.00:0.00:0.50:0.50     ; Example of mixing
{endif}

-----------------------------------------------------------------------------------------------------------------------
 VERSION HISTORY
-----------------
v2.2.1 (2020-05-03) New! User-Defined Windows Defender Port Blocking Delay. Minor Bug Fixes.
