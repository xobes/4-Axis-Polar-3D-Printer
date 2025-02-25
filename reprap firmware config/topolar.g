; Home axies
; M98 P"homeall.g"

; Drives
M584 Y0 Z4 X1:2 U1 V2 E3       ; set drive mapping polar
M569 P0 S1                     ; physical drive 0 (C) goes forwards using TMC2209 driver timings
M569 P1 S0 D3 V40            ; physical drive 1 (Bottom) goes reverse using TMC2209 driver timings
M569 P2 S1 D3 V40            ; physical drive 2 (Top) goes reverse using TMC2209 driver timings
M569 P3 S0                     ; physical drive 3 (E) goes reverse using TMC2209 driver timings
M569 P4 S1                     ; physical drive 4 (Z) goes forwards using TMC2209 driver timings

M350 Y16       X16       Z16                        E16      I1  ; configure microstepping with interpolation
M92  Y88.8888  X100.00   Z400.00   U22.2222 V22.222 E932.00      ; set steps per mm
M566 Y600.00   X600.00   Z600.00   U600     V600    E300.00      ; set maximum instantaneous speed changes (mm/min)
M203 Y20000.00 X20000.00 Z8000.00  U30000   V30000  E3600.00     ; set maximum speeds (mm/min)
M201 Y2000.00  X2000.00  Z1500.00  U2000    V2000   E2000.00     ; set accelerations (mm/s^2)
M906 Y1500               Z1500     U1500    V1500   E800     I30 ; set motor currents (mA) and motor idle factor in per cent

;M84 S30                                                   ; Set idle timeout

; Axis Limits
M208 X-103 Y-103 Z0   S1                              ; set axis minima. Some compensation for b axis sensorless homing
M208 X103  Y103  Z200 S0                              ; set axis maxima
;;; 
;;;; Axis Limits
;;;; Note: The values specified set the software limits for axis travel in the specified direction. 
;;;; Note: The axis limits you set are also the positions assumed when an endstop is triggered.
;;;; ... Therefore:
;;;;     - Endstop for X MAXima is the value set while homing. i.e. Positive is from center of Bed toward Z axis tower
;;;;     - Endstop for B MINima is the value set while homing. i.e. Positive from home is down toward Bed.
;;;;     - Endstop for Z MINima is the bed surface itself (by definition zero)
;;;;     - C has no endstops or minima/maxima, hence the really large values
;;;M208 C-20000000  X-37.5 Z0    B-90.9  S1          ; set axis minima
;;;M208 C20000000   X98.5  Z200  B90     S0          ; set axis maxima


; define mesh grid
;M557 R110 S50                                                  

; Configure endstops and Z-Probe settings
; Z -------------------------------------
;;; polar ;;; M574 Z1 S2                                                ; configure Z-probe endstop for low end on Z
M558 P5 C"!e1stop" H5 F500   ; set Z probe type to "switch" and the dive height + speeds
G31 P500 X0 Y0 Z-22.25       ; set Z probe trigger value, offset and trigger height
M574 Z1 S2                   ; use z-probe for limit sensing on lower z-limit while homing

; X -------------------------------------
;;; polar ;;; M574 X2 S3                                                ; configure sensorless endstop for high end on X
; M574 X2 S1 P"!xstop"         ; configure limit switch endstop for high end on X
M574 X2 S3                 ; polar original...

; B -------------------------------------
;;; polar ;;; M915 X B R0 F0 S-10                                       ; sensorless endstop configuration
;; TODO FIX THIS
;;M574 B1 S3           	     ; configure sensorless endstop for low end on B
;;M915 B R0 F0 S60             ; Configure motor stall detection for the B-axis, R0=no action, F0=unfiltered, S=threshhold
M915 X B R0 F0 S10     	     ; sensorless endstop configuration

; Define Kinematics
M669 K7 R103 H103 F200.00 A5000.00 S4000 T0.1    ; polar printer

; Say where we are
; G92 X0 Y0 Z5 B0 C0 U0 V0

; Run mesh bed leveling
; G29 S0