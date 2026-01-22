#FILE NAMES
PKG_FILE = package.sv
TOP_FILE = top.sv
TOP = top

COV_UCDB = coverage.ucdb
COV_DIR = covReport

#test
test ?= dma_test #default

#compile
comp:
	@vlog +define+UVM_NO_DPI $(TOP_FILE) "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"

run:
	@vsim -c +UVM_NO_DPI $(TOP) -do "run -all; exit;"

bd_comp:
	@vlog -sv +acc +rw $(TOP_FILE) "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src" 

bd_run:
	vsim -c -voptargs=+acc=npr $(TOP) -do "run -all; exit"

sim:


clean:
	@rm -rf transcript vsim.wlf work *.log $(COV_LOG_FILE) $(COV_UCDB) $(COV_DIR) wave.vcd vsim.wlf


