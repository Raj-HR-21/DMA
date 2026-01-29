class dma_reg_block extends uvm_reg_block;
    `uvm_object_utils(dma_reg_block)
    rand reg_intr intr_h;
    rand reg_ctrl ctrl_h;
    rand reg_io_addr io_addr_h;
    rand reg_mem_addr mem_addr_h;
    rand reg_extra_info extra_info_h;
    rand reg_status status_h;
    rand reg_transfer_count transfer_count_h;
    rand reg_descriptor_addr descriptor_addr_h;
    rand reg_error_status error_status_h;
    rand reg_config config_h;
    
    uvm_reg_map reg_map;
    
    function new(string name = "dma_reg_block");
        super.new(name, UVM_CVR_ALL);
    endfunction: new
    
    function void build();
        uvm_reg::include_coverage("*", UVM_CVR_ALL);
        //add hdl path
        add_hdl_path("top.dut", "RTL");

        // 1. INTR 0x400
        intr_h = reg_intr::type_id::create("intr_h");
        intr_h.build();
        intr_h.configure(this);
        void'(intr_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 2. CTRL 0x404
        ctrl_h = reg_ctrl::type_id::create("ctrl_h");
        ctrl_h.build();
        ctrl_h.configure(this);
        void'(ctrl_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 3. IO_ADDR 0x408
        io_addr_h = reg_io_addr::type_id::create("io_addr_h");
        io_addr_h.build();
        io_addr_h.configure(this);
        void'(io_addr_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 4. MEM_ADDR 0x40C
        mem_addr_h = reg_mem_addr::type_id::create("mem_addr_h");
        mem_addr_h.build();
        mem_addr_h.configure(this);
        void'(mem_addr_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 5. EXTRA_INFO 0x410
        extra_info_h = reg_extra_info::type_id::create("extra_info_h");
        extra_info_h.build();
        extra_info_h.configure(this);
        void'(extra_info_h.set_coverage(UVM_CVR_FIELD_VALS));

        // 6. STATUS 0x414
        status_h = reg_status::type_id::create("status_h");
        status_h.build();
        status_h.configure(this);
        void'(status_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 7. TRANSFER_COUNT 0x418
        transfer_count_h = reg_transfer_count::type_id::create("transfer_count_h");
        transfer_count_h.build();
        transfer_count_h.configure(this);
        void'(transfer_count_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 8. DESCRIPTOR_ADDR 0x41C
        descriptor_addr_h = reg_descriptor_addr::type_id::create("descriptor_addr_h");
        descriptor_addr_h.build();
        descriptor_addr_h.configure(this);
        void'(descriptor_addr_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 9. ERROR_STATUS 0x420
        error_status_h = reg_error_status::type_id::create("error_status_h");
        error_status_h.build();
        error_status_h.configure(this);
        void'(error_status_h.set_coverage(UVM_CVR_FIELD_VALS));
        
        // 10. CONFIG 0x424
        config_h = reg_config::type_id::create("config_h");
        config_h.build();
        config_h.configure(this);
        void'(config_h.set_coverage(UVM_CVR_FIELD_VALS));

        // hdl slice
        intr_h.add_hdl_path_slice("intr_status", 0, 16);
        intr_h.add_hdl_path_slice("intr_mask", 16, 16);

        ctrl_h.add_hdl_path_slice("ctrl_start_dma", 0, 1);
        ctrl_h.add_hdl_path_slice("ctrl_w_count", 1, 15);
        ctrl_h.add_hdl_path_slice("ctrl_io_mem", 16, 1);

        io_addr_h.add_hdl_path_slice("io_addr", 0, 32);

        mem_addr_h.add_hdl_path_slice("mem_addr", 0, 32);

        extra_info_h.add_hdl_path_slice("extra_info", 0, 32);

        status_h.add_hdl_path_slice("status_busy",  0, 1);
        status_h.add_hdl_path_slice("status_done",  1, 1);
        status_h.add_hdl_path_slice("status_error", 2, 1);
        status_h.add_hdl_path_slice("status_paused",3, 1);
        status_h.add_hdl_path_slice("status_current_state", 4, 4);
        status_h.add_hdl_path_slice("status_fifo_level",    8, 8);

        transfer_count_h.add_hdl_path_slice("transfer_count", 0, 32);

        descriptor_addr_h.add_hdl_path_slice("descriptor_addr", 0, 32);

        error_status_h.add_hdl_path_slice("error_bus", 0, 1);
        error_status_h.add_hdl_path_slice("error_timeout", 1, 1);
        error_status_h.add_hdl_path_slice("error_alignment", 2, 1);
        error_status_h.add_hdl_path_slice("error_overflow", 3, 1);
        error_status_h.add_hdl_path_slice("error_underflow", 4, 1);
        error_status_h.add_hdl_path_slice("error_code", 8, 8);
        error_status_h.add_hdl_path_slice("error_addr_offset", 16, 16);

        config_h.add_hdl_path_slice("config_priority", 0, 2);
        config_h.add_hdl_path_slice("config_auto_restart", 2, 1);
        config_h.add_hdl_path_slice("config_interrupt_enable", 3, 1);
        config_h.add_hdl_path_slice("config_burst_size", 4, 2);
        config_h.add_hdl_path_slice("config_data_width", 6, 2);
        config_h.add_hdl_path_slice("config_descriptor_mode", 8, 1);

        // address map
        reg_map = create_map("reg_map", 'h0, 4, UVM_LITTLE_ENDIAN);
        reg_map.add_reg(intr_h, 'h400, "RW");
        reg_map.add_reg(ctrl_h, 'h404, "RW");
        reg_map.add_reg(io_addr_h, 'h408, "RW");
        reg_map.add_reg(mem_addr_h, 'h40C, "RW");
        reg_map.add_reg(extra_info_h, 'h410, "RW");
        reg_map.add_reg(status_h, 'h414, "RO");
        reg_map.add_reg(transfer_count_h, 'h418, "RO");
        reg_map.add_reg(descriptor_addr_h, 'h41C, "RW");
        reg_map.add_reg(error_status_h, 'h420, "RW");
        reg_map.add_reg(config_h, 'h424, "RW");

        lock_model();
    endfunction: build 

endclass: dma_reg_block


