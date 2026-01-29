class dma_predictor#(type BUSTYPE = int) extends uvm_reg_predictor#(dma_seq_item);
    `uvm_component_utils(dma_predictor#(BUSTYPE))

    function new(string name = "dma_predictor", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void write(dma_seq_item tr);
        uvm_reg register;
     
        uvm_reg_bus_op rw;
        super.write(tr);
        adapter.bus2reg(tr, rw);
       
        register = map.get_reg_by_offset(tr.addr, (rw.kind == UVM_READ));

        register.sample_values();

    endfunction: write
endclass: dma_predictor

