vlib work
vlog datapath.v
vlog datapath_tb.v
vsim -c work.datapath_tb
run -all
quit -f
