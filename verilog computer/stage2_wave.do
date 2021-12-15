onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TESTBENCH
add wave -noupdate /lab7bonus_stage2_tb/CLOCK_50
add wave -noupdate /lab7bonus_stage2_tb/err
add wave -noupdate /lab7bonus_stage2_tb/err
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/datapath_out
add wave -noupdate /lab7bonus_stage2_tb/DUT/Z
add wave -noupdate /lab7bonus_stage2_tb/DUT/N
add wave -noupdate /lab7bonus_stage2_tb/DUT/V
add wave -noupdate {/lab7bonus_stage2_tb/LEDR[8]}
add wave -noupdate -radix unsigned {/lab7bonus_stage2_tb/DUT/MEM/mem[20]}
add wave -noupdate -divider FSM
add wave -noupdate -radix unsigned /lab7bonus_stage2_tb/DUT/CPU/FSM/fsm_state
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/opcode
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/op
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/cond
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/Z
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/N
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/V
add wave -noupdate -divider REGFILE
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R0
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R2
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R3
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R6
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/REGFILE/R7
add wave -noupdate -divider CPU
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/instruction
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/opcode
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/op
add wave -noupdate /lab7bonus_stage2_tb/DUT/read_data
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/PC
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/FSM/load_pc
add wave -noupdate -divider DATAPATH
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/datapath_in
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/vsel
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/readnum
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/loada
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/loadb
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/regA_out
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/regB_out
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/asel
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/bsel
add wave -noupdate /lab7bonus_stage2_tb/DUT/CPU/DP/ALUop
add wave -noupdate -radix hexadecimal /lab7bonus_stage2_tb/DUT/CPU/DP/alu_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {833 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 341
configure wave -valuecolwidth 117
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
WaveRestoreZoom {2066 ps} {2434 ps}
