`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dma_intf.sv"
`include "dma_design.v"
`include "package.svh"
import dma_pkg::*;

module top;

    bit clk, rst_n;
    dma_intf intf(clk, rst_n);

    // dut instance
    dma_design dut(.clk(clk), .rst_n(rst_n), .wr_en(intf.wr_en), .rd_en(intf.rd_en), .wdata(intf.wdata), .addr(intf.addr), .rdata(intf.rdata));
    
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst_n = 0;

        #10 rst_n = 1;
    end

    initial begin
        uvm_config_db#(virtual dma_intf)::set(null, "*", "vif", intf);
    end

    initial begin
	run_test("dma_test_1");
  end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars();
    end

endmodule

