; homeall.g
; called to home all axes
;
if move.kinematics.name == "Polar"
    G91
    M400
    
    G1 H1 Z25 F12000   ; lift Z relative to current position

    M569 P1 V1        ; put driver 1 into stealth chop mode
    M569 P2 V1        ; put driver 2 into stealth chop mode
    M84               ; disable motors
    M17               ; enable motors
    
    M400
    ;G1 H1 U0.1 V0.1 F100   ; wake up driver
    
    ;;;;;;;;;;;;;;;;;;;
    ;;; HOME B AXIS ;;;
    ;;;;;;;;;;;;;;;;;;;
    M913 U60 V60          ; change current limits

    ; Do the B axis homing, B coordinates are in degrees
    ; V (Driver 2) is TOP, U (Driver 1) is BOTTOM.
    ; G1 H2 is just moves the drivers -- NOT the axis (kinematics not applied) -- direct drive
    M915 U V R0 F0 S35

    ; half of these are fake values, just so we have values and will apply sensorless homing
    M574 U1 S3 ; temporary limit so that we don't short out the driver if we're near the center, harmless
    M574 U2 S3 ; temporary limit so that we don't short out the driver if we're near the center, harmless
    M574 V1 S3 ; temporary limit so that we don't short out the driver if we're near the center, harmless
    M574 V2 S3 ; temporary limit so that we don't short out the driver if we're near the center, harmless
    M208 V89.5 U-90   S1
    M208 V90   U-89.5 S0
        
    ; slide X back to maximum
    G1 H1 U1200 V1200 F100000
    
    ; First pass --------------------------------------------------------
    ; swing B away from the endstop
    M84 V M17 U           ; disable the top motor / enable bottom
    G1 H1 U60 F200000
    G4 P200

    ; swing B towards the endstop from potentially far away (first pass)
    M84 U M17 V           ; disable the bottom motor / enable top
    G1 H1 V740 F200000
    G4 P200

    ; Second pass --------------------------------------------------------
    ; swing B away from the endstop
    M84 V M17 U           ; disable the top motor / enable bottom
    G1 H1 U90 F200000
    G4 P200

    ; swing B towards the endstop
    M84 U M17 V           ; disable the bottom motor / enable top
    G1 H1 V300 F200000
    G4 P200
    ; --------------------------------------------------------------------
    M17 U V
    G92 U-90 V90
    
    ; set U/V limits
    M208 V-300 U-90 S1
    M208 V90   U300 S0
    M400

    ;;;;;;;;;;;;;;;;;;;
    ;;; HOME RADIUS ;;;
    ;;;;;;;;;;;;;;;;;;;
    ; --------------------------------------------------------------------
    G92 X102.8
    ; --------------------------------------------------------------------

    M913 U100 V100    ; change current limits
    M569 P1 V4000     ; put driver 1 into spread cycle mode
    M569 P2 V4000     ; put driver 2 into spread cycle mode
    M400
    
    ;;;;;;;;;;;;;;;;
    ;;; HOME BED ;;;
    ;;;;;;;;;;;;;;;;    
    G90              ; absolute movement
    G1 H2 X0 F10000  ; move to middle
    G92 X0 Y0 ; define current position as X0 Y0

    M98 P"homez.g"
    
else
    M98 P"homey.g"
    M98 P"homec.g"
    M98 P"homeb.g"
    M98 P"homex.g"
    M98 P"homez.g"

