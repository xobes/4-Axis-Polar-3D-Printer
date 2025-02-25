G91                ; relative positioning
M400

if move.kinematics.name == "Polar"
    M400
else
    ; lift the Z axis to avoid dragging the tip accross the build plate
    M913 Z100
    G1 H2 Z25 F6000 ; casually lift up

    ; Do the X axis homing:
    ; B (Driver 2) is TOP, X (Driver 1) is BOTTOM.
    G1 H2 X-10 B10 F90000 ; go back (towards the print bed) a few mm
    G1 H1 X150 F10000     ; move quickly to X axis endstop and stop there (first pass)

    ; Second pass
    G1 H2 X-10 B10 F90000 ; go back (towards the print bed) a few mm
    G1 H1 X20 F1000       ; move more slowly to X axis endstop once more (second pass)

    ; Restore Settings:
    M913 X100 B100          ; return current to 100%

    G90                     ; retore absolute positioning
    M400