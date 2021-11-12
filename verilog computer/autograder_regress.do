vlib work
vlog lab5_top.v
vlog lab5_autograder_check.v
vsim -c work.lab5_check_1; run -all
vsim -c work.lab5_check_2; run -all
vsim -c work.lab5_check_3; run -all
vsim -c work.lab5_check_4; run -all
quit -f
