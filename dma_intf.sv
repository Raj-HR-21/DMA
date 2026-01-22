interface dma_intf(input bit clk, input bit rst_n);

    logic wr_en;
    logic rd_en;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic [31:0] addr;

    clocking drv_cb@(posedge clk);
        default input #0 output #0;
        output wr_en, rd_en, rdata, wdata, addr;
    endclocking
    clocking mon_cb@(posedge clk);
        default input #0 output #0;
        input wr_en, rd_en, rdata, wdata, addr;
    endclocking

    modport drv_mp(clocking drv_cb, input rst_n);
    modport mon_mp(clocking mon_cb, input rst_n);

endinterface

