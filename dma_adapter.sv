class dma_adapter extends uvm_reg_adapter;
    `uvm_object_utils(dma_adapter);

    function new(string name = "dma_adapter");
        super.new(name);
    endfunction

    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        dma_seq_item tr;
        tr = dma_seq_item::type_id::create("tr");
        tr.wr_en = (rw.kind == UVM_WRITE);
        tr.rd_en = (rw.kind == UVM_READ);
        tr.addr  = rw.addr;
        tr.wdata = (rw.kind == UVM_WRITE) ? rw.data : 0;
        return tr;

    endfunction: reg2bus

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        dma_seq_item tr;

        assert($cast(tr, bus_item));

        rw.addr = tr.addr;
        rw.status = UVM_IS_OK;

        if(tr.wr_en) begin
            rw.data = tr.wdata;
            rw.kind = UVM_WRITE;
        end
        if(tr.rd_en) begin
            rw.data = tr.rdata;
            rw.kind = UVM_READ;
        end

    endfunction: bus2reg

endclass: dma_adapter

