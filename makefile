#FILE NAMES
PKG_FILE = package.sv
TOP_FILE = top.sv
TOP = top
test ?= dma_test_1

COV_UCDB = coverage.ucdb
COV_DIR = covReport


#compile
#comp:
#	make clean
#	vlog +define+UVM_NO_DPI $(TOP_FILE) "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"

#run:
#	vsim -c +UVM_NO_DPI $(TOP) -do "run -all; exit;"

#backdoor access
comp:
	make clean
	vlog -sv +define+UVM_NO_DPI +acc +cover +fcover -l log.log  $(TOP_FILE) "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"

run:
	vsim -c +UVM_NO_DPI -vopt $(TOP) -voptargs=+acc=npr -do "run -all; exit" +UVM_TESTNAME=$(test)

cov:
	vlog -sv +acc +cover +fcover -l log.log top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit" +UVM_TESTNAME=regression_test
	vcover report -html coverage.ucdb -htmldir covReport -details
	
wave:
	make clean
	vlog -sv +define+UVM_NO_DPI +acc +cover +fcover -l log.log  $(TOP_FILE) "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"
	vsim -novopt -suppress 12110 top

clean:
	@rm -rf transcript vsim.wlf work *.log $(COV_LOG_FILE) $(COV_UCDB) $(COV_DIR) wave.vcd vsim.wlf vsim_stacktrace.vstf


