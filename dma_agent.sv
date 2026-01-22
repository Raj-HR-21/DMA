class dma_agent extends uvm_agent;
    `uvm_component_utils(dma_agent)
    dma_driver drv_h;
    dma_monitor mon_h;
    dma_sequencer sqr_h;

    function new(string name = "dma_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        drv_h = dma_driver::type_id::create("drv_h", this);
        sqr_h = dma_sequencer::type_id::create("sqr_h", this);
        mon_h = dma_monitor::type_id::create("mon_h", this);
    endfunction: build_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

            drv_h.seq_item_port.connect(sqr_h.seq_item_export);
    endfunction: connect_phase

endclass: dma_agent

