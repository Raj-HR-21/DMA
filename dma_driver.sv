class dma_driver extends uvm_driver#(dma_seq_item);
    `uvm_component_utils(dma_driver)
    virtual dma_intf vif;
	dma_seq_item req;

    function new(string name = "dma_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if( !(uvm_config_db#(virtual dma_intf)::get(this, "", "vif", vif) ))
            `uvm_error("DRIVER", "NO VIRTUAL INTERFACE IN DRIVER")
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        repeat(1)@(vif.drv_cb);
        forever begin

            seq_item_port.get_next_item(req);
            drive_task(req);
            seq_item_port.item_done();
        end
    endtask: run_phase

    task drive_task(dma_seq_item tx);
        vif.addr  <= tx.addr;
        vif.wr_en <= tx.wr_en;
        vif.rd_en <= tx.rd_en;
        if(tx.wr_en && !tx.rd_en) begin
            vif.wdata <= tx.wdata;
            $display("-------------------------------------------------------------------------------------------");
            `uvm_info(" DRV WRITE ", $sformatf("\n WR_EN = %b | RD_EN = %b | ADDR = %8h | WDATA = %8h | \n", tx.wr_en, tx.rd_en, tx.addr, tx.wdata), UVM_LOW)
            repeat(2)@(vif.drv_cb);
        end else vif.wdata <= 0;
        if(!tx.wr_en && tx.rd_en) begin
        repeat(1)@(vif.drv_cb);
            tx.rdata = vif.rdata;
            $display("-------------------------------------------------------------------------------------------");
            `uvm_info(" DRV READ ", $sformatf("\n WR_EN = %b | RD_EN = %b | ADDR = %8h | WDATA = %8h | RDATA = %8h  \n", tx.wr_en, tx.rd_en, tx.addr, tx.wdata, tx.rdata), UVM_LOW)
            repeat(1)@(vif.drv_cb);
        end

    endtask: drive_task

endclass: dma_driver

