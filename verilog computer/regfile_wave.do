onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /regfile_tb/sim_clk
add wave -noupdate /regfile_tb/sim_data_in
add wave -noupdate /regfile_tb/sim_writenum
add wave -noupdate /regfile_tb/sim_write
add wave -noupdate /regfile_tb/sim_readnum
add wave -noupdate /regfile_tb/dut/data_out
add wave -noupdate /regfile_tb/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 304
configure wave -valuecolwidth 125
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
WaveRestoreZoom {0 ps} {843 ps}
