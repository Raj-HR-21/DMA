class reg_intr extends uvm_reg;
    `uvm_object_utils(reg_intr)
    rand uvm_reg_field intr_status; //ro
    rand uvm_reg_field intr_mask;   //rw

    covergroup cg_intr;
        cp_mask: coverpoint intr_mask.value[15:0] {
            bins vals[3] = {[16'h1 : 16'hFFFF]};
        }
    endgroup: cg_intr

    function new(string name = "reg_intr");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_intr = new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_intr.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_intr.sample();
    endfunction: sample_values

    function void build();
        intr_status = uvm_reg_field::type_id::create("intr_status");
        intr_status.configure(  .parent(this), .size(16), .lsb_pos(0), .access("RO"), .volatile(1), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1)   );

        intr_mask = uvm_reg_field::type_id::create("intr_mask");
        intr_mask.configure(    .parent(this), .size(16), .lsb_pos(16), .access("RW"), .volatile(0), .reset(16'h0000), .has_reset(1), .is_rand(1), .individually_accessible(1)  );

    endfunction

endclass: reg_intr
// --------------------------------------------------------
class reg_ctrl extends uvm_reg;
    `uvm_object_utils(reg_ctrl)
    rand uvm_reg_field start_dma;   //rw
    rand uvm_reg_field w_count;     //rw
    rand uvm_reg_field io_mem;      //rw
    rand uvm_reg_field reserved;    //ro

    covergroup cg_ctrl;
        cp_status: coverpoint start_dma.value[0]{
            bins min = {0};
            bins max = {1};
        }
        cp_w_count: coverpoint w_count.value[15:1] { 
            bins vals[3] = {[15'h1 : 15'h7FFF]};
        }
        cp_io_mem: coverpoint io_mem.value[16]{
            bins min = {0};
            bins max = {1};
        }
    endgroup: cg_ctrl

    function new(string name = "reg_ctrl");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_ctrl = new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_ctrl.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_ctrl.sample();
    endfunction: sample_values

    function void build();
        start_dma = uvm_reg_field::type_id::create("start_dma");
        start_dma.configure(    .parent(this), .size(1), .lsb_pos(0), .access("RW"), .volatile(1), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1)   );

        w_count = uvm_reg_field::type_id::create("w_count");
        w_count.configure(  .parent(this), .size(15), .lsb_pos(1), .access("RW"), .volatile(0), .reset(15'h0000), .has_reset(1), .is_rand(1), .individually_accessible(1)   );

        io_mem = uvm_reg_field::type_id::create("io_mem");
        io_mem.configure(   .parent(this), .size(1), .lsb_pos(16), .access("RW"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1)  );

        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure( .parent(this), .size(15), .lsb_pos(17), .access("RO"), .volatile(1), .reset(15'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1)  );

    endfunction

endclass: reg_ctrl
// --------------------------------------------------------
class reg_io_addr extends uvm_reg;
    `uvm_object_utils(reg_io_addr)
    rand uvm_reg_field io_addr;	//rw

    covergroup cg_io_addr;
        cp_io_addr: coverpoint io_addr.value[31:0]{ 
            bins vals[3] = {[32'h1 : 32'hFFFF_FFFF]};
        }
    endgroup: cg_io_addr

    function new(string name = "reg_io_addr");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_io_addr = new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_io_addr.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_io_addr.sample();
    endfunction: sample_values

    function void build();
        io_addr = uvm_reg_field::type_id::create("io_addr");
        io_addr.configure(	.parent(this), .size(32), .lsb_pos(0), .access("RW"), .volatile(0), .reset(32'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

    endfunction

endclass: reg_io_addr

// --------------------------------------------------------
class reg_mem_addr extends uvm_reg;
    `uvm_object_utils(reg_mem_addr)
    rand uvm_reg_field mem_addr;	//rw

    covergroup cg_mem_addr;
        cp_mem_addr: coverpoint mem_addr.value[31:0]{ 
            bins vals[3] = {[32'h1 : 32'hFFFF_FFFF]};
        }
    endgroup: cg_mem_addr

    function new(string name = "reg_mem_addr");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_mem_addr = new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_mem_addr.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_mem_addr.sample();
    endfunction: sample_values

    function void build();
        mem_addr = uvm_reg_field::type_id::create("mem_addr");
        mem_addr.configure( .parent(this), .size(32), .lsb_pos(0), .access("RW"), .volatile(0), .reset(32'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

    endfunction

endclass: reg_mem_addr

// --------------------------------------------------------
class reg_extra_info extends uvm_reg;
    `uvm_object_utils(reg_extra_info)
    rand uvm_reg_field extra_info;	//rw

    covergroup cg_extra_info;
        cp_extra_info: coverpoint extra_info.value[31:0]{ 
            bins vals[3] = {[32'h1 : 32'hFFFF_FFFF]};
        }
    endgroup: cg_extra_info

    function new(string name = "reg_extra_info");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_extra_info= new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_extra_info.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_extra_info.sample();
    endfunction: sample_values

    function void build();
        extra_info = uvm_reg_field::type_id::create("extra_info");
        extra_info.configure(	.parent(this), .size(32), .lsb_pos(0), .access("RW"), .volatile(0), .reset(32'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

    endfunction

endclass: reg_extra_info

// --------------------------------------------------------
class reg_status extends uvm_reg;
    `uvm_object_utils(reg_status)
    rand uvm_reg_field busy;	//ro
    rand uvm_reg_field done;	//ro
    rand uvm_reg_field error;	//ro
    rand uvm_reg_field paused;	//ro
    rand uvm_reg_field current_state;	//ro
    rand uvm_reg_field fifo_level;		//ro
    rand uvm_reg_field reserved;		//ro

    function new(string name = "reg_status");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction: new

    function void build();
        busy = uvm_reg_field::type_id::create("busy");
        busy.configure(	.parent(this), .size(1), .lsb_pos(0), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

        done = uvm_reg_field::type_id::create("done");
        done.configure(	.parent(this), .size(1), .lsb_pos(1), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

        error = uvm_reg_field::type_id::create("error");
        error.configure( .parent(this), .size(1), .lsb_pos(2), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

        paused = uvm_reg_field::type_id::create("paused");
        paused.configure( .parent(this), .size(1), .lsb_pos(3), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

        current_state = uvm_reg_field::type_id::create("current_state");
        current_state.configure( .parent(this), .size(4), .lsb_pos(4), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

        fifo_level = uvm_reg_field::type_id::create("fifo_level");
        fifo_level.configure( .parent(this), .size(8), .lsb_pos(8), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure( .parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

    endfunction

endclass: reg_status

// --------------------------------------------------------
class reg_transfer_count extends uvm_reg;
    `uvm_object_utils(reg_transfer_count)
    rand uvm_reg_field transfer_count;	//ro

    function new(string name = "reg_transfer_count");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction: new

    function void build();
        transfer_count = uvm_reg_field::type_id::create("transfer_count");
        transfer_count.configure( .parent(this), .size(32), .lsb_pos(0), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

    endfunction

endclass: reg_transfer_count

// --------------------------------------------------------
class reg_descriptor_addr extends uvm_reg;
    `uvm_object_utils(reg_descriptor_addr)
    rand uvm_reg_field descriptor_addr;	//rw

    covergroup cg_descriptor_addr;
        cp_status: coverpoint descriptor_addr.value[31:0]{ 
            bins vals[3] = {[32'h1 : 32'hFFFF_FFFF]};
        }
    endgroup: cg_descriptor_addr

    function new(string name = "reg_descriptor_addr");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_descriptor_addr = new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_descriptor_addr.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_descriptor_addr.sample();
    endfunction: sample_values

    function void build();
        descriptor_addr = uvm_reg_field::type_id::create("descriptio_addr");
        descriptor_addr.configure(	.parent(this), .size(32), .lsb_pos(0), .access("RW"), .volatile(0), .reset(32'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

    endfunction

endclass: reg_descriptor_addr

// --------------------------------------------------------
class reg_error_status extends uvm_reg;
    `uvm_object_utils(reg_error_status)
    rand uvm_reg_field bus_error;			//rw1c
    rand uvm_reg_field timeout_error;		//rw1c
    rand uvm_reg_field alignment_error;		//rw1c
    rand uvm_reg_field overflow_error;		//rw1c
    rand uvm_reg_field underflow_error;		//rw1c
    rand uvm_reg_field reserved;		//ro
    rand uvm_reg_field error_code;		//ro
    rand uvm_reg_field error_addr_offset; 	//ro

    function new(string name = "reg_error_status");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction: new

    function void build();
        bus_error = uvm_reg_field::type_id::create("bus_error");
        bus_error.configure( .parent(this), .size(1), .lsb_pos(0), .access("W1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

        timeout_error = uvm_reg_field::type_id::create("timeout_error");
        timeout_error.configure( .parent(this), .size(1), .lsb_pos(1), .access("W1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

        alignment_error = uvm_reg_field::type_id::create("alignment_error");
        alignment_error.configure( .parent(this), .size(1), .lsb_pos(2), .access("W1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

        overflow_error = uvm_reg_field::type_id::create("overflow_error");
        overflow_error.configure( .parent(this), .size(1), .lsb_pos(3), .access("W1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

        underflow_error = uvm_reg_field::type_id::create("underflow_error");
        underflow_error.configure( .parent(this), .size(1), .lsb_pos(4), .access("W1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure( .parent(this), .size(3), .lsb_pos(5), .access("RO"), .volatile(1), .reset(3'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

        error_code = uvm_reg_field::type_id::create("error_code");
        error_code.configure( .parent(this), .size(8), .lsb_pos(8), .access("RO"), .volatile(1), .reset(8'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

        error_addr_offset = uvm_reg_field::type_id::create("error_addr_offset");
        error_addr_offset.configure( .parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(1), .reset(16'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));


    endfunction

endclass: reg_error_status

// --------------------------------------------------------
class reg_config extends uvm_reg;
    `uvm_object_utils(reg_config)
    rand uvm_reg_field Priority;		//rw
    rand uvm_reg_field auto_restart;	//rw
    rand uvm_reg_field interrupt_enable;	//rw
    rand uvm_reg_field burst_size;		//rw
    rand uvm_reg_field data_width;		//rw
    rand uvm_reg_field descriptor_mode;	//rw
    rand uvm_reg_field reserved;		//ro

    covergroup cg_config;
        cp_priority: coverpoint Priority.value[1:0]{
            bins priority_bins[2] = {0,1,2,3};
        }
        cp_auto_restart: coverpoint auto_restart.value[2]{
            bins min = {0};
            bins max = {1};
        }
        cp_interrupt_enable: coverpoint interrupt_enable.value[3]{
            bins min = {0};
            bins max = {1};
        }
        cp_burst_size: coverpoint burst_size.value[5:4]{
            bins burst_size_bins[] = {0,1,2,3};
        }
        cp_data_width: coverpoint data_width.value[7:6]{
            bins vals[2] = {0,1,2,3};
        }
        cp_descriptor_mode: coverpoint descriptor_mode.value[8]{
            bins min = {0};
            bins max = {1};
        }

    endgroup: cg_config

    function new(string name = "reg_config");
        super.new(name, 32, UVM_CVR_FIELD_VALS);
        if(has_coverage(UVM_CVR_FIELD_VALS)) 
            cg_config = new();
    endfunction: new

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        cg_config.sample();
    endfunction: sample
    virtual function void sample_values();
        super.sample_values();
        cg_config.sample();
    endfunction: sample_values

    function void build();
        Priority = uvm_reg_field::type_id::create("Priority");
        Priority.configure(.parent(this), .size(2), .lsb_pos(0), .access("RW"), .volatile(0), .reset(2'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

        auto_restart = uvm_reg_field::type_id::create("auto_restart");
        auto_restart.configure(	.parent(this), .size(1), .lsb_pos(2), .access("RW"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

        interrupt_enable = uvm_reg_field::type_id::create("interrupt_enable");
        interrupt_enable.configure( .parent(this), .size(1), .lsb_pos(3), .access("RW"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

        burst_size = uvm_reg_field::type_id::create("burst_size");
        burst_size.configure( .parent(this), .size(2), .lsb_pos(4), .access("RW"), .volatile(0), .reset(2'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

        data_width = uvm_reg_field::type_id::create("data_width");
        data_width.configure( .parent(this), .size(2), .lsb_pos(6), .access("RW"), .volatile(0), .reset(2'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

        descriptor_mode = uvm_reg_field::type_id::create("descriptor_mode");
        descriptor_mode.configure( .parent(this), .size(1), .lsb_pos(8), .access("RW"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure( .parent(this), .size(23), .lsb_pos(9), .access("RO"), .volatile(1), .reset(23'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

    endfunction

endclass: reg_config

