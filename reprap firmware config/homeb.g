G91                ; relative positioning

; lift the Z axis to avoid dragging the tip accross the build plate
M913 Z100
G1 H2 Z25 F6000 ; casually lift up

; set up stealth chop mode (always) for these X/B axis
M913 X80 B80       ; reduce motor current
M569 P1 V1          ; Force driver 1 to stay in stealth chop mode
M569 P2 V1          ; Force driver 2 to stay in stealth chop mode
M400


; Do the B axis homing, B coordinates are in degrees
; B (Driver 2) is TOP, X (Driver 1) is BOTTOM.
; G1 H2 is just moves the drivers -- NOT the axis (kinematics not applied) -- direct drive
G1 H2 X10 B10 F90000   ; swing B away from the end stop
G1 H1 B-320 F90000  ; swing B towards the endstop from potentially far away (first pass)

G4 P500

; Second pass
G1 H1 B90 F90000     ; swing B away from the end stop for another approach
G1 H1 B-110 F60000   ; swing B towards the endstop once more, a bit slower this time
M400

; Restore X/B settings:
M913 X100 B100          ; return current to 100%
M569 P1 V4000           ; put driver 1 into spread cycle mode
M569 P2 V4000           ; put driver 2 into spread cycle mode

; inspect our results
G90 B-90
M400