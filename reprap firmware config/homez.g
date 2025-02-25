if move.kinematics.name == "Polar"
    G90
    M913 U100 V100          ; return current to 100%
    G1 H2 U-90 V90          ; align for Z-probe
    M400

    ;;;;;;;;;;;;;;
    ;;; HOME Z ;;;
    ;;;;;;;;;;;;;;
    G1 X0 Y0          ; move to center of bed
    G30
    G1 H2 Z0 F2000

    ; Face nozzle down
    G1 H2 U0 V0 F2000 
    G92 U0 V0
    
    g1 x0 y0 z0
else

    G91               ; relative positioning
    G1 H2 Z25 F6000   ; lift Z relative to current position
    
    G90
    G1 X0 B-90        ; move to center of bed, extruder nozzle straight out (sensor straight down)

    ; find the bed for the first time (quickly)
    G91               ; relative positioning
    G1 H1 Z-150 F4000 ; lower z until limit found

    ; lift a little for second approach
    G91               ; relative positioning
    G1 Z5 F6000       ; lift Z relative to current position
    G30               ; Probe the bed with the Z-Probe
    
    G90               ; absolute positioning
    G1 Z25 F10000     ; lift Z to absolution Z25

    g1 z0 b0 x0