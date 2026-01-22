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
        $display("Apply reset to reg");
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
// frontdoor
class reg_sequence extends uvm_sequence#(dma_seq_item);
    `uvm_object_utils(reg_sequence)

    dma_reg_block  top_reg_h;
    uvm_status_e   status;
    uvm_reg_data_t wdata;
    uvm_reg_data_t rdata;
    uvm_reg_data_t des;
    uvm_reg_data_t mir;

    function new(string name = "reg_sequence");
        super.new(name);
    endfunction

    task body();

        // 1. INTR_REG ro
        top_reg_h.intr_h.write(status, 32'hAAAA_AAAA, UVM_FRONTDOOR);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)

        top_reg_h.intr_h.read(status, rdata, UVM_FRONTDOOR);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 2. CTRL REG rw
        top_reg_h.ctrl_h.write(status, 32'h1234_5678, UVM_FRONTDOOR);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata, UVM_FRONTDOOR);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 3. IO_ADDR rw
        top_reg_h.io_addr_h.write(status, 32'h1024_040C, UVM_FRONTDOOR);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.io_addr_h.read(status, rdata, UVM_FRONTDOOR);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 4. MEM_ADDR rw
        top_reg_h.mem_addr_h.write(status, 32'hABCD_EF00, UVM_FRONTDOOR);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.mem_addr_h.read(status, rdata, UVM_FRONTDOOR);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 5. EXTRA_INFO rw
        top_reg_h.extra_info_h.write(status, 32'h1122_3344, UVM_FRONTDOOR);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.extra_info_h.read(status, rdata, UVM_FRONTDOOR);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 6. STATUS ro
        top_reg_h.status_h.write(status, 32'hABCD_0001, UVM_FRONTDOOR);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.status_h.read(status, rdata);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.write(status, 32'h5555_5555);
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
        top_reg_h.config_h.write(status, 32'hA1B2_C3D4);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf("Write: des = %0h | mir = %0h", des, mir), UVM_LOW)
        top_reg_h.config_h.read(status, rdata);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf("Read: des = %0h | mir = %0h", des, mir), UVM_LOW)

//*/
/*
        // 1. INTR_REG ro
        top_reg_h.intr_h.write(status, 32'hAAAA_AAAA);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.intr_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.intr_h.get();
        mir = top_reg_h.intr_h.get_mirrored_value();
        `uvm_info("SEQ-INTR", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 2. CTRL REG rw
        top_reg_h.ctrl_h.write(status, 32'h1234_1234);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.ctrl_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.ctrl_h.get();
        mir = top_reg_h.ctrl_h.get_mirrored_value();
        `uvm_info("SEQ-CTRL", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 3. IO_ADDR rw
        top_reg_h.io_addr_h.write(status, 32'h1024_040C);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.io_addr_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.io_addr_h.get();
        mir = top_reg_h.io_addr_h.get_mirrored_value();
        `uvm_info("SEQ-IO_ADDR", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 4. MEM_ADDR rw
        top_reg_h.mem_addr_h.write(status, 32'hABCD_EF00);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.mem_addr_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.mem_addr_h.get();
        mir = top_reg_h.mem_addr_h.get_mirrored_value();
        `uvm_info("SEQ-MEM_ADDR", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 5. EXTRA_INFO rw
        top_reg_h.extra_info_h.write(status, 32'h1122_1122);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.extra_info_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.extra_info_h.get();
        mir = top_reg_h.extra_info_h.get_mirrored_value();
        `uvm_info("SEQ-EXTRA_INFO", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 6. STATUS ro
        top_reg_h.status_h.write(status, 32'hABCD_0001);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.status_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.status_h.get();
        mir = top_reg_h.status_h.get_mirrored_value();
        `uvm_info("SEQ-STATUS", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.write(status, 32'h5555_5555);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.transfer_count_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.transfer_count_h.get();
        mir = top_reg_h.transfer_count_h.get_mirrored_value();
        `uvm_info("SEQ-TRANSFER_COUNT", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 8. DESCRIPTOR_ADDR ro
        top_reg_h.descriptor_addr_h.write(status, 32'hA5A5_A5A5);
        des = top_reg_h.descriptor_addr_h.get();
        mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
        `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.descriptor_addr_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.descriptor_addr_h.get();
        mir = top_reg_h.descriptor_addr_h.get_mirrored_value();
        `uvm_info("SEQ-DESCRIPTOR_ADDR", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 9. ERROR_STATUS rw1c
        top_reg_h.error_status_h.write(status, 32'h1234_ABCD);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.error_status_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.error_status_h.get();
        mir = top_reg_h.error_status_h.get_mirrored_value();
        `uvm_info("SEQ-ERROR_STATUS", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)

        // 10. CONFIG rw
        top_reg_h.config_h.write(status, 32'hA1B2_C3D4);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf("\n Write: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
        top_reg_h.config_h.read(status, rdata, UVM_BACKDOOR);
        des = top_reg_h.config_h.get();
        mir = top_reg_h.config_h.get_mirrored_value();
        `uvm_info("SEQ-CONFIG", $sformatf("\n Read: des = %0h | mir = %0h\n ", des, mir), UVM_LOW)
*/
    endtask: body

endclass

