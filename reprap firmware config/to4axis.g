; Notes on physical configuration:
; C (Driver 0) is the bed, Positive is ????  CW/CCW?
; X (Driver 1) is BOTTOM \_ The combination of Driver 1 and 2 drives "B" (extruder angle) and "X" in and out radially
; B (Driver 2) is TOP    /  ...B is Positive DOWN from homing position, X is Positive AWAY from bed Center.
; Z (Driver 4) is obvious..., Positive is UP
; Extruder (Driver 3) is obvious as well.

; Drives
M584 C0 Z4 X1 B2 E3 S0         ; set drive mapping 4 axis. treat all as linear axes in feedrate calculations (have to use inverse time feed rate in gcode)
M569 P0 S1                     ; physical drive 0 (C) goes forwards using TMC2209 driver timings
M569 P1 S0  D3 V40             ; physical drive 1 (Bottom) goes reverse using TMC2209 driver timings
M569 P2 S0  D3 V40             ; physical drive 2 (Top) goes reverse using TMC2209 driver timings
M569 P3 S0                     ; physical drive 3 (E) goes reverse using TMC2209 driver timings
M569 P4 S1                     ; physical drive 4 (Z) goes forwards using TMC2209 driver timings

M350 C16       X16       Z16      B16       E16      I1  ; configure microstepping with interpolation
M92  C88.8888  X100.00   Z400.00  B100.00   E932.00      ; set steps per mm
M566 C600.00   X600.00   Z600.00  B600.00   E300.00      ; set maximum instantaneous speed changes (mm/min)
M203 C21600.00 X20000.00 Z8000.00 B21600.00 E3600.00     ; set maximum speeds (mm/min)
M201 C2000.00  X5000.00  Z1500.00 B2000.00  E2000.00     ; set accelerations (mm/s^2)
M906 C1500     X1500     Z1000    B1500     E800     I30 ; set motor currents (mA) and motor idle factor (in percent)

; Axis Limits
; Note: The values specified set the software limits for axis travel in the specified direction. 
; Note: The axis limits you set are also the positions assumed when an endstop is triggered.
; ... Therefore:
;     - Endstop for X MAXima is the value set while homing. i.e. Positive is from center of Bed toward Z axis tower
;     - Endstop for B MINima is the value set while homing. i.e. Positive from home is down toward Bed.
;     - Endstop for Z MINima is the bed surface itself (by definition zero)
;     - C has no endstops or minima/maxima, hence the really large values
M208 C-20000000  X-37.5 Z0    B-90.9  S1          ; set axis minima
M208 C20000000   X98.5  Z200  B90     S0          ; set axis maxima

; Configure endstops and Z-Probe settings
; Z -------------------------------------
M558 P5 C"!e1stop" H5 F500   ; set Z probe type to "switch" and the dive height + speeds
G31 P500 X0 Y0 Z-22.25       ; set Z probe trigger value, offset and trigger height
M574 Z1 S2                   ; use z-probe for limit sensing on lower z-limit while homing
; X -------------------------------------
M574 X2 S1 P"!xstop"         ; configure limit switch endstop for high end on X
; B -------------------------------------
M574 B1 S3           	     ; configure sensorless endstop for low end on B
M915 B R0 F0 S60             ; Configure motor stall detection for the B-axis, R0=no action, F0=unfiltered, S=threshhold

; Define Kinematics
; Driver:1:-:4:2:0  1:-:4:2 :0  1:-:4:2:0           1:-:4:2          :0
;   Axis:X:Y:Z:B:C  X:Y:Z:B :C  X:Y:Z:B:C           X:Y:Z:B          :C
M669 K0 C0:0:0:0:1 X1:0:0:-1:0 Z0:0:1:0:0 B0.22222222:0:0:0.222222222:0 ; 4 axis control
; X and Z coordinates are in millimeters
; B coordinates are in degrees
; C coordinates are ... ??? TBD