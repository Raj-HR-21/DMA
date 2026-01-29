class reset_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(reset_seq)

    dma_reg_block  top_reg_h;
    uvm_status_e   status;
    uvm_reg_data_t wdata;
    uvm_reg_data_t rdata;
    uvm_reg_data_t des;
    uvm_reg_data_t mir;

    function new(string name = "reset_seq");
        super.new(name);
    endfunction: new

    task body();
        // apply reset
        `uvm_info(" RESET-SEQ", "Apply reset to reg", UVM_LOW);
        top_reg_h.reset();
        top_reg_h.intr_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("INTR-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.ctrl_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("CNTR-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.io_addr_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("IO_ADDR-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.mem_addr_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("MEM_ADDR-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.extra_info_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("EXTRA_INFO-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.status_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("STATUS-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.transfer_count_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("TRANSFER_COUNT-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.descriptor_addr_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("DESCRIPTOR_ADDR-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.error_status_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("ERROR_STATUS-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

        top_reg_h.config_h.read(status, rdata, UVM_BACKDOOR);
        if(rdata != 32'h0) `uvm_info("CONFIG-RST", $sformatf("\n RESET VALUE IS NOT CORRECT\n "), UVM_LOW)

    endtask: body

endclass: reset_seq
// -------------------------------------------------------------
// FRONTDOOR WRITE and FRONTDOOR READ
class reg_seq_1 extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(reg_seq_1)

    dma_reg_block  top_reg_h;
    uvm_status_e   status;
    uvm_reg_data_t wdata;
    uvm_reg_data_t rdata;
    uvm_reg_data_t des;
    uvm_reg_data_t mir;

    function new(string name = "reg_seq_1");
        super.new(name);
    endfunction

    task body();

        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- FRONTDOOR WRITE and FRONTDOOR READ ----------- ");
        // 1. INTR_REG ro
        top_reg_h.intr_h.write(status, 32'hAAAA_AAAA);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)

        top_reg_h.intr_h.read(status, rdata);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 2. CTRL REG rw
        top_reg_h.ctrl_h.write(status, 32'h1234_5678);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 3. IO_ADDR rw
        top_reg_h.io_addr_h.write(status, 32'h1024_040C);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.io_addr_h.read(status, rdata);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 4. MEM_ADDR rw
        top_reg_h.mem_addr_h.write(status, 32'hABCD_EF00);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.mem_addr_h.read(status, rdata);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 5. EXTRA_INFO rw
        top_reg_h.extra_info_h.write(status, 32'h1A2B_3C4D);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.extra_info_h.read(status, rdata);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 6. STATUS ro
        top_reg_h.status_h.write(status, 32'hABCD_0001);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.status_h.read(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.write(status, 32'hAAAA_5555);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.transfer_count_h.read(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 8. DESCRIPTOR_ADDR ro
        top_reg_h.descriptor_addr_h.write(status, 32'hA5A5_B6B6);
        des = top_reg_h.descriptor_addr_h.get();
        mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
        `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.descriptor_addr_h.read(status, rdata);
        des = top_reg_h.descriptor_addr_h.get();
        mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
        `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 9. ERROR_STATUS rw1c
        top_reg_h.error_status_h.write(status, 32'h1234_ABCD);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.error_status_h.read(status, rdata);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 10. CONFIG rw
        top_reg_h.config_h.write(status, 32'hFFFF_FFFF);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.config_h.read(status, rdata);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

    endtask: body

endclass: reg_seq_1
// -------------------------------------------------------------------------------------------------------------
// FRONTDOOR WRITE and BACKDOOR READ
class reg_seq_2 extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(reg_seq_2)

    dma_reg_block  top_reg_h;
    uvm_status_e   status;
    uvm_reg_data_t wdata;
    uvm_reg_data_t rdata;
    uvm_reg_data_t des;
    uvm_reg_data_t mir;

    function new(string name = "reg_seq_2");
        super.new(name);
    endfunction

    task body();

        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- FRONTDOOR WRITE and BACKDOOR READ ----------- ");
        // 1. INTR_REG ro
        top_reg_h.intr_h.write(status, 32'hAAAA_AAAA);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.intr_h.peek(status, rdata);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 2. CTRL REG rw
        top_reg_h.ctrl_h.write(status, 32'h1234_4321);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.peek(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 3. IO_ADDR rw
        top_reg_h.io_addr_h.write(status, 32'h1024_040C);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.io_addr_h.peek(status, rdata);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 4. MEM_ADDR rw
        top_reg_h.mem_addr_h.write(status, 32'hABCD_EF00);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.mem_addr_h.peek(status, rdata);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 5. EXTRA_INFO rw
        top_reg_h.extra_info_h.write(status, 32'hAA55_BB66);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.extra_info_h.peek(status, rdata);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 6. STATUS ro
        top_reg_h.status_h.write(status, 32'hABCD_4321);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.status_h.peek(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.write(status, 32'hAABB_CCDD);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.transfer_count_h.peek(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 8. DESCRIPTOR_ADDR ro
        top_reg_h.descriptor_addr_h.write(status, 32'hA1B1_A2B2);
        des = top_reg_h.descriptor_addr_h.get();
        mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
        `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.descriptor_addr_h.peek(status, rdata);
        des = top_reg_h.descriptor_addr_h.get();
        mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
        `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 9. ERROR_STATUS rw1c
        top_reg_h.error_status_h.write(status, 32'h1234_ABCD);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.error_status_h.peek(status, rdata);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 10. CONFIG rw
        top_reg_h.config_h.write(status, 32'hA1B2_C3D4);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf(" Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.config_h.peek(status, rdata);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

    endtask: body

endclass: reg_seq_2

// -------------------------------------------------------------
class intr_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(intr_seq)

    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "intr_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- INTR FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.intr_h.write(status, wdata);
            des = top_reg_h.intr_h.get();
            mir = top_reg_h.intr_h.get_mirrored_value();
            `uvm_info("SEQ-INTR", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.intr_h.peek(status, rdata);
            des = top_reg_h.intr_h.get();
            mir = top_reg_h.intr_h.get_mirrored_value();
            `uvm_info("SEQ-INTR", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.intr_h.mirror(status, UVM_CHECK);
            des = top_reg_h.intr_h.get();
            mir = top_reg_h.intr_h.get_mirrored_value();
            `uvm_info("SEQ-INTR", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end

        // Multiple write-read
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- INTR Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.intr_h.write(status, wdata);
            des = top_reg_h.intr_h.get();
            mir = top_reg_h.intr_h.get_mirrored_value();
            `uvm_info("SEQ-INTR", $sformatf(" Write: des = %0h | mir = %0h\n", des, mir), UVM_LOW)

            top_reg_h.intr_h.mirror(status, UVM_CHECK);
            des = top_reg_h.intr_h.get();
            mir = top_reg_h.intr_h.get_mirrored_value();
            `uvm_info("SEQ-INTR", $sformatf(" Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        end

    endtask: body
endclass: intr_seq

// --------------------------------------------------------
class ctrl_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(ctrl_seq)

    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "ctrl_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR)
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- CTRL ----------- ");
        top_reg_h.ctrl_h.write(status, 32'h1234_4321);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.peek(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" FD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        top_reg_h.ctrl_h.write(status, 32'h0);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.peek(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" FD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        top_reg_h.ctrl_h.write(status, 32'hFFFF_FFFF);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.peek(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" FD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- CTRL FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.ctrl_h.write(status, wdata);
            des = top_reg_h.ctrl_h.get();
            mir = top_reg_h.ctrl_h.get_mirrored_value();
            `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
            top_reg_h.ctrl_h.peek(status, rdata);
            des = top_reg_h.ctrl_h.get();
            mir = top_reg_h.ctrl_h.get_mirrored_value();
            `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

            top_reg_h.ctrl_h.mirror(status, UVM_CHECK);
            des = top_reg_h.ctrl_h.get();
            mir = top_reg_h.ctrl_h.get_mirrored_value();
            `uvm_info("SEQ-CTRL", $sformatf(" FD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        end
        // Multiple write-read
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- CTRL Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.ctrl_h.write(status, wdata);
            des = top_reg_h.ctrl_h.get();
            mir = top_reg_h.ctrl_h.get_mirrored_value();
            `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
            top_reg_h.ctrl_h.peek(status, rdata);
            des = top_reg_h.ctrl_h.get();
            mir = top_reg_h.ctrl_h.get_mirrored_value();
            `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
            top_reg_h.ctrl_h.mirror(status, UVM_CHECK);
            des = top_reg_h.ctrl_h.get();
            mir = top_reg_h.ctrl_h.get_mirrored_value();
            `uvm_info("SEQ-CTRL", $sformatf(" FD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        end

    endtask: body
endclass: ctrl_seq
// --------------------------------------------------------
class io_addr_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(io_addr_seq)

    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "io_addr_seq");
        super.new(name);
    endfunction: new

    task body;
        // Multiple write-read
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- IO_ADDR Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.io_addr_h.write(status, wdata);
            des = top_reg_h.io_addr_h.get();
            mir = top_reg_h.io_addr_h.get_mirrored_value();
            `uvm_info("SEQ-IO_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.io_addr_h.mirror(status, UVM_CHECK);
            des = top_reg_h.io_addr_h.get();
            mir = top_reg_h.io_addr_h.get_mirrored_value();
            `uvm_info("SEQ-IO_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end
    endtask: body
endclass: io_addr_seq
// --------------------------------------------------------
class mem_addr_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(mem_addr_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "mem_addr_seq");
        super.new(name);
    endfunction: new

    task body;
        // Multiple write-read
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- MEM_ADDR Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.mem_addr_h.write(status, wdata);
            des = top_reg_h.mem_addr_h.get();
            mir = top_reg_h.mem_addr_h.get_mirrored_value();
            `uvm_info("SEQ-MEM_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.mem_addr_h.mirror(status, UVM_CHECK);
            des = top_reg_h.mem_addr_h.get();
            mir = top_reg_h.mem_addr_h.get_mirrored_value();
            `uvm_info("SEQ-MEM_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end
    endtask: body

endclass: mem_addr_seq

// --------------------------------------------------------
class extra_info_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(extra_info_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "extra_info_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- EXTRA_INFO FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.extra_info_h.write(status, wdata, UVM_FRONTDOOR);
            des = top_reg_h.extra_info_h.get();
            mir = top_reg_h.extra_info_h.get_mirrored_value();
            `uvm_info("SEQ-EXTRA_INFO", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.extra_info_h.peek(status, rdata);
            des = top_reg_h.extra_info_h.get();
            mir = top_reg_h.extra_info_h.get_mirrored_value();
            `uvm_info("SEQ-EXTRA_INFO", $sformatf("BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.extra_info_h.mirror(status, UVM_CHECK);
            des = top_reg_h.extra_info_h.get();
            mir = top_reg_h.extra_info_h.get_mirrored_value();
            `uvm_info("SEQ-EXTRA_INFO", $sformatf("FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.extra_info_h.write(status, wdata);
            des = top_reg_h.extra_info_h.get();
            mir = top_reg_h.extra_info_h.get_mirrored_value();
            `uvm_info("SEQ-EXTRA_INFO", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.extra_info_h.mirror(status, UVM_CHECK);
            des = top_reg_h.extra_info_h.get();
            mir = top_reg_h.extra_info_h.get_mirrored_value();
            `uvm_info("SEQ-EXTRA_INFO", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end

    endtask: body
endclass: extra_info_seq

// --------------------------------------------------------
class status_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(status_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "status_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- STATUS FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        top_reg_h.status_h.write(status, 32'hA5B6_8A92);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf(" FD Write: des = %b | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.status_h.peek(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf(" BD Read: des = %b | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.status_h.read(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf(" FD Read: des = %b | mir = %0h", des, mir), UVM_LOW)

        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- STATUS Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.status_h.write(status, wdata);
            des = top_reg_h.status_h.get();
            mir = top_reg_h.status_h.get_mirrored_value();
            `uvm_info("SEQ-STATUS", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.status_h.mirror(status, UVM_CHECK);
            des = top_reg_h.status_h.get();
            mir = top_reg_h.status_h.get_mirrored_value();
            `uvm_info("SEQ-STATUS", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end

    endtask: body
endclass: status_seq

// --------------------------------------------------------
class transfer_count_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(transfer_count_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "transfer_count_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- TRANSFER_COUNT FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        wdata = 32'h0;
        top_reg_h.extra_info_h.write(status, wdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)

        top_reg_h.transfer_count_h.peek(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        top_reg_h.transfer_count_h.mirror(status, UVM_CHECK);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- TRANSFER_COUNT Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.extra_info_h.write(status, wdata);
            des = top_reg_h.transfer_count_h.get();
            mir = top_reg_h.transfer_count_h.get_mirrored_value();
            `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)

            top_reg_h.transfer_count_h.peek(status, rdata);
            des = top_reg_h.transfer_count_h.get();
            mir = top_reg_h.transfer_count_h.get_mirrored_value();
            `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

            top_reg_h.transfer_count_h.mirror(status, UVM_CHECK);
            des = top_reg_h.transfer_count_h.get();
            mir = top_reg_h.transfer_count_h.get_mirrored_value();
            `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end
    endtask: body
endclass: transfer_count_seq


// --------------------------------------------------------
class descriptor_addr_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(descriptor_addr_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "descriptor_addr_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- DESCRIPTOR_ADDR FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.descriptor_addr_h.write(status, wdata);
            des = top_reg_h.descriptor_addr_h.get();
            mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
            `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.descriptor_addr_h.peek(status, rdata);
            des = top_reg_h.descriptor_addr_h.get();
            mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
            `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.descriptor_addr_h.mirror(status, UVM_CHECK);
            des = top_reg_h.descriptor_addr_h.get();
            mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
            `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end

    endtask: body
endclass: descriptor_addr_seq

// --------------------------------------------------------
class error_status_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(error_status_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "error_status_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR)
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- ERROR_STATUS FRONTDOOR WRITE and READ( BACKDOOR, FRONTDOOR) ----------- ");
        wdata = 32'hABCD_127F;
        top_reg_h.error_status_h.write(status, wdata);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.error_status_h.peek(status, rdata);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.error_status_h.mirror(status, UVM_CHECK);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- ERROR_STATUS FRONTDOOR WRITE aand READ( BACKDOOR, FRONTDOOR) ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.error_status_h.write(status, wdata);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)

            top_reg_h.error_status_h.peek(status, rdata);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.error_status_h.mirror(status, UVM_CHECK);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end

        // WRITE( BACKDOOR, FRONTDOOR) and READ( BACKDOOR, FRONTDOOR)
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- ERROR_STATUS WRITE( BACKDOOR, FRONTDOOR) and READ( BACKDOOR, FRONTDOOR) ----------- ");
        repeat(05)begin
        $display(" ========================================================================================================= ");
            wdata = $urandom;
            top_reg_h.error_status_h.poke(status, wdata); // BACKDOOR WRITE
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" BD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.error_status_h.peek(status, rdata);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.error_status_h.mirror(status, UVM_CHECK);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

            wdata = 32'hFFFF_FFFF;
            top_reg_h.error_status_h.write(status, wdata); // FRONTDOOR WRITE
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)

            top_reg_h.error_status_h.peek(status, rdata);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.error_status_h.mirror(status, UVM_CHECK);
            des = top_reg_h.error_status_h.get();
            mir = top_reg_h.error_status_h.get_mirrored_value();
            `uvm_info("SEQ-ERROR_STATUS", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        end

    endtask: body
endclass: error_status_seq

// --------------------------------------------------------
class config_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(config_seq)
    dma_reg_block top_reg_h;
    uvm_status_e status;
    uvm_reg_data_t wdata, rdata, des, mir;

    function new(string name = "config_seq");
        super.new(name);
    endfunction: new

    task body;

        // FRONTDOOR WRITE and FRONTDOOR READ
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- CONFIG FRONTDOOR WRITE and FRONTDOOR READ ----------- ");
        repeat(10) begin
            wdata = 32'h0;
            top_reg_h.config_h.write(status, wdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.peek(status, rdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.mirror(status, UVM_CHECK);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

            wdata = 32'hFFFF_FFFF;
            top_reg_h.config_h.write(status, wdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.peek(status, rdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.mirror(status, UVM_CHECK);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

            wdata = 32'hFFFF_FF7F;
            top_reg_h.config_h.write(status, wdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.peek(status, rdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.mirror(status, UVM_CHECK);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

            wdata = 32'hFFFF_FFFA;
            top_reg_h.config_h.write(status, wdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.peek(status, rdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.mirror(status, UVM_CHECK);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

            wdata = 32'hFFFF_FFD7;
            top_reg_h.config_h.write(status, wdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.peek(status, rdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" BD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.mirror(status, UVM_CHECK);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
        end
        $display("-------------------------------------------------------------------------------------------");
        $display(" --------- CONFIG Multiple write-read ----------- ");
        repeat(10) begin
            wdata = $urandom;
            top_reg_h.config_h.write(status, wdata);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
            top_reg_h.config_h.mirror(status, UVM_CHECK);
            des = top_reg_h.config_h.get();
            mir = top_reg_h.config_h.get_mirrored_value();
            `uvm_info("SEQ-CONFIG", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        end

    endtask: body
endclass: config_seq
// --------------------------------------------------------
class regression_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(regression_seq)

    dma_reg_block top_reg_h;

    intr_seq s1;
    ctrl_seq s2;
    io_addr_seq s3;
    mem_addr_seq s4;
    extra_info_seq s5;
    status_seq s6;
    transfer_count_seq s7;
    descriptor_addr_seq s8;
    error_status_seq s9;
    config_seq s10;

    reset_seq rst;
    reg_seq_1 s11;
    reg_seq_2 s12;

    function new(string name = "regression_seq");
        super.new(name);
    endfunction: new

    task body();
repeat(20) begin

        s11 = reg_seq_1::type_id::create("s11");
        s11.top_reg_h = top_reg_h;
        s11.start(m_sequencer);

        s12 = reg_seq_2::type_id::create("s12");
        s12.top_reg_h = top_reg_h;
        s12.start(m_sequencer);

end
/*
        repeat(01) begin
            rst = reset_seq::type_id::create("rst");
            rst.top_reg_h = top_reg_h;
            rst.start(m_sequencer);

            s1 = intr_seq::type_id::create("s1");
            s1.top_reg_h = top_reg_h;
            s1.start(m_sequencer);

            s2 = ctrl_seq::type_id::create("s2");
            s2.top_reg_h = top_reg_h;
            s2.start(m_sequencer);

            s3 = io_addr_seq::type_id::create("s3");
            s3.top_reg_h = top_reg_h;
            s3.start(m_sequencer);

            s4 = mem_addr_seq::type_id::create("s4");
            s4.top_reg_h = top_reg_h;
            s4.start(m_sequencer);

            s5 = extra_info_seq::type_id::create("s5");
            s5.top_reg_h = top_reg_h;
            s5.start(m_sequencer);

            s6 = status_seq::type_id::create("s6");
            s6.top_reg_h = top_reg_h;
            s6.start(m_sequencer);

            s7 = transfer_count_seq::type_id::create("s7");
            s7.top_reg_h = top_reg_h;
            s7.start(m_sequencer);

            s8 = descriptor_addr_seq::type_id::create("s8");
            s8.top_reg_h = top_reg_h;
            s8.start(m_sequencer);

            s9 = error_status_seq::type_id::create("s9");
            s9.top_reg_h = top_reg_h;
            s9.start(m_sequencer);

            s10 = config_seq::type_id::create("s10");
            s10.top_reg_h = top_reg_h;
            s10.start(m_sequencer);

        end
*/
    endtask: body

endclass: regression_seq

// --------------------------------------------------------
class sample_seq extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(sample_seq)

    dma_reg_block  top_reg_h;
    uvm_status_e   status;
    uvm_reg_data_t wdata;
    uvm_reg_data_t rdata;
    uvm_reg_data_t des;
    uvm_reg_data_t mir;

    function new(string name = "sample_seq");
        super.new(name);
    endfunction: new

    task body();
	repeat(25) begin
	$display(" //////////////////////////////////////////////////////////////////////////////////////////// ");
        // 2. CTRL REG rw
        wdata = $urandom; 
$display("wdata = %0h", wdata);
wdata[0]=0; //wdata[15:1] = $urandom_range(10, 15);
$display("wdata = %0h", wdata);

        top_reg_h.ctrl_h.write(status, wdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        $display("\t\t\t wdata : start_dma = %0h | w_count = %0h | io_mem = %0h", wdata[0], wdata[15:1], wdata[16]);
        $display("\t\t\t wdata :  %b", wdata);
        `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
/*
        top_reg_h.ctrl_h.peek(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
*/		
		// 6. STATUS ro
       
        top_reg_h.status_h.peek(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        $display("\t\t\t rdata :  busy = %0h | done = %0h | error = %0h | paused = %0h | cs = %0h | fifo_lvl = %0h", rdata[0], rdata[1], rdata[2], rdata[3], rdata[7:4], rdata[15:8] ); 
        $display("\t\t\t rdata :  %b", rdata);
        `uvm_info("SEQ-STATUS", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        top_reg_h.status_h.read(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        $display("\t\t\t rdata :  busy = %0h | done = %0h | error = %0h | paused = %0h | cs = %0h | fifo_lvl = %0h", rdata[0], rdata[1], rdata[2], rdata[3], rdata[7:4], rdata[15:8] ); 
        $display("\t\t\t rdata :  %b", rdata);
        `uvm_info("SEQ-STATUS", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.peek(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        $display("\t\t\t rdata :  %b", rdata);
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.transfer_count_h.read(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

	$display(" ======================================================================================== ");
        // 2. CTRL REG rw
        wdata = $urandom; 
$display("wdata = %0h", wdata);
wdata[0]=1; //wdata[15:1] = $urandom_range(10, 15);
$display("wdata = %0h", wdata);
        top_reg_h.ctrl_h.write(status, wdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        $display("\t\t\t wdata : start_dma = %0h | w_count = %0h | io_mem = %0h", wdata[0], wdata[15:1], wdata[16]);
        $display("\t\t\t wdata :  %b", wdata);
        `uvm_info("SEQ-CTRL", $sformatf(" FD Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
/*
        top_reg_h.ctrl_h.peek(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
*/
        // 6. STATUS ro
        top_reg_h.status_h.peek(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        $display("\t\t\t rdata :  busy = %0h | done = %0h | error = %0h | paused = %0h | cs = %0h | fifo_lvl = %0h", rdata[0], rdata[1], rdata[2], rdata[3], rdata[7:4], rdata[15:8] ); 
        $display("\t\t\t rdata :  %b", rdata);
        `uvm_info("SEQ-STATUS", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        top_reg_h.status_h.read(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        $display("\t\t\t rdata :  busy = %0h | done = %0h | error = %0h | paused = %0h | cs = %0h | fifo_lvl = %0h", rdata[0], rdata[1], rdata[2], rdata[3], rdata[7:4], rdata[15:8] ); 
        $display("\t\t\t rdata :  %b", rdata);
        `uvm_info("SEQ-STATUS", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.peek(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" BD Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.transfer_count_h.read(status, rdata);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf(" FD Read: des = %0h | mir = %0h", des, mir), UVM_LOW)
	end
	endtask: body
	
endclass: sample_seq
