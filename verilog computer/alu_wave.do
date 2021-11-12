onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/sim_A
add wave -noupdate /alu_tb/sim_B
add wave -noupdate /alu_tb/sim_op
add wave -noupdate /alu_tb/sim_out
add wave -noupdate /alu_tb/sim_Z
add wave -noupdate /alu_tb/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 166
configure wave -valuecolwidth 115
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {122 ps}
