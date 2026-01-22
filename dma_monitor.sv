class dma_monitor extends uvm_monitor;
    `uvm_component_utils(dma_monitor)

    virtual dma_intf vif;
    uvm_analysis_port#(dma_seq_item) ap;
    dma_seq_item in_item;

    function new(string name = "dma_monitor",  uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       	ap = new("ap", this);
        if( !(uvm_config_db#(virtual dma_intf)::get(this, "", "vif", vif) ))
            `uvm_error("MONITOR", "NO VIRTUAL INTERFACE IN MONITOR")
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        repeat(1)@(vif.mon_cb);
        forever begin
            in_item = dma_seq_item::type_id::create("in_item");
            repeat(3)@(vif.mon_cb);

            in_item.wr_en = vif.wr_en;
            in_item.rd_en = vif.rd_en;
            in_item.wdata = vif.wdata;
            in_item.addr  = vif.addr;
            in_item.rdata = vif.rdata;

            `uvm_info("MON ", $sformatf("\n WR_EN = %b | RD_EN = %b | ADDR = %8h | WDATA = %8h | RDATA = %8h \n", in_item.wr_en, in_item.rd_en, in_item.addr, in_item.wdata, in_item.rdata ), UVM_LOW)
          //repeat(1)@(vif.mon_cb);
            ap.write(in_item);
        end
    endtask: run_phase


endclass: dma_monitor

