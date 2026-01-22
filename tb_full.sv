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
        repeat(2)@(vif.drv_cb);
        forever begin
            seq_item_port.get_next_item(req);
            drive_task(req);
            seq_item_port.item_done();
        end
    endtask: run_phase

    task drive_task(dma_seq_item tx);

        vif.wr_en <= tx.wr_en;
        vif.rd_en <= tx.rd_en;
        vif.addr  <= tx.addr;
        vif.wdata <= tx.wr_en ? tx.wdata : 0;

        `uvm_info(" DRV ", $sformatf("\n WR_EN = %b | RD_EN = %b | ADDR = %32h | WDATA = %32h | \n", tx.wr_en, tx.rd_en, tx.addr, tx.wdata), UVM_LOW)
        repeat(3)@(vif.drv_cb);

    endtask: drive_task

endclass: dma_driver

class dma_env extends uvm_env;
    `uvm_component_utils(dma_env)
    dma_agent agt_h;
    dma_reg_block top_reg_h;
    reg_adapter adapter_h;
    uvm_reg_predictor#(dma_seq_item) predictor_h;

    function new(string name = "dma_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt_h = dma_agent::type_id::create("agt_h", this);
		//predictor
        predictor_h = uvm_reg_predictor#(dma_seq_item)::type_id::create("predictor_h", this);

		// register top block
        top_reg_h = dma_reg_block::type_id::create("top_reg_h", this);
        top_reg_h.build();

		//adapter
        adapter_h = reg_adapter::type_id::create("adapter_h", this);


    endfunction: build_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
		// connect reg model and sequencer
        top_reg_h.reg_map.set_sequencer(agt_h.sqr_h, adapter_h);

		// connect predictor instance and reg_model map and adapter instance
        predictor_h.map = top_reg_h.reg_map;
        predictor_h.adapter = adapter_h;

        agt_h.mon_h.ap.connect(predictor_h.bus_in);

		top_reg_h.reg_map.set_auto_predict(0);

    endfunction: connect_phase

endclass: dma_env

interface dma_intf(input bit clk, input bit rst);

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

    modport drv_mp(clocking drv_cb, input rst);
    modport mon_mp(clocking mon_cb, input rst);

endinterface

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
        repeat(2)@(vif.mon_cb);
        forever begin
            in_item = dma_seq_item::type_id::create("in_item");
            repeat(1)@(vif.mon_cb);
            in_item.wr_en = vif.wr_en;
            in_item.rd_en = vif.rd_en;
            in_item.wdata = vif.wdata;
            in_item.addr  = vif.addr;
            in_item.rdata = vif.rdata;
            
            ap.write(in_item);
            `uvm_info("MON ", $sformatf("\n WR_EN = %b | RD_EN = %b | ADDR = %32h | WDATA = %32h | RDATA = %32h \n", in_item.wr_en, in_item.rd_en, in_item.addr, in_item.wdata, in_item.rdata ), UVM_LOW)
            repeat(3)@(vif.mon_cb);
        end
    endtask: run_phase


endclass: dma_monitor

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
        // 1. INTR 0x400
        intr_h = reg_intr::type_id::create("intr_h");
        intr_h.build();
        intr_h.configure(this);
        intr_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 2. CTRL 0x404
        ctrl_h = reg_ctrl::type_id::create("ctrl_h");
        ctrl_h.build();
        ctrl_h.configure(this);
        ctrl_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 3. IO_ADDR 0x408
        io_addr_h = reg_io_addr::type_id::create("io_addr_h");
        io_addr_h.build();
        io_addr_h.configure(this);
        io_addr_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 4. MEM_ADDR 0x40C
        mem_addr_h = reg_mem_addr::type_id::create("mem_addr_h");
        mem_addr_h.build();
        mem_addr_h.configure(this);
        mem_addr_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 5. EXTRA_INFO 0x410
        extra_info_h = reg_extra_info::type_id::create("extra_info_h");
        extra_info_h.build();
        extra_info_h.configure(this);
        extra_info_h.set_coverage(UVM_CVR_FIELD_VALS);

        
        // 6. STATUS 0x414
        status_h = reg_status::type_id::create("status_h");
        status_h.build();
        status_h.configure(this);
        status_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 7. TRANSFER_COUNT 0x418
        transfer_count_h = reg_transfer_count::type_id::create("transfer_count_h");
        transfer_count_h.build();
        transfer_count_h.configure(this);
        transfer_count_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 8. DESCRIPTOR_ADDR 0x41C
        descriptor_addr_h = reg_descriptor_addr::type_id::create("descriptor_addr_h");
        descriptor_addr_h.build();
        descriptor_addr_h.configure(this);
        descriptor_addr_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 9. ERROR_STATUS 0x420
        error_status_h = reg_error_status::type_id::create("error_status_h");
        error_status_h.build();
        error_status_h.configure(this);
        error_status_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        // 10. CONFIG 0x424
        config_h = reg_config::type_id::create("config_h");
        config_h.build();
        config_h.configure(this);
        config_h.set_coverage(UVM_CVR_FIELD_VALS);
        
        //
        reg_map = create_map("reg_map", 'h0, 4, UVM_LITTLE_ENDIAN);
        reg_map.add_reg(intr_h, 'h400, "RO");
        reg_map.add_reg(ctrl_h, 'h404, "RW");
        reg_map.add_reg(io_addr_h, 'h408, "RW");
        reg_map.add_reg(mem_addr_h, 'h40C, "RW");
        reg_map.add_reg(extra_info_h, 'h410, "RW");
        reg_map.add_reg(status_h, 'h414, "RO");
        reg_map.add_reg(transfer_count_h, 'h418, "RO");
        reg_map.add_reg(descriptor_addr_h, 'h41C, "RW");
        reg_map.add_reg(error_status_h, 'h420, "RW1C");
        reg_map.add_reg(config_h, 'h424, "RW");

        lock_model();
    endfunction: build 
    
endclass: dma_reg_block


class dma_seq_item extends uvm_sequence_item;

    rand logic wr_en;
    rand logic rd_en;  
    rand logic [31:0] addr;
    rand logic [31:0] wdata;
    logic [31:0] rdata;

    `uvm_object_utils_begin(dma_seq_item)
    `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_field_int(rd_en, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="dma_seq_item");
        super.new(name);
    endfunction

endclass: dma_seq_item

class dma_sequencer extends uvm_sequencer#(dma_seq_item);
    `uvm_component_utils(dma_sequencer)

    function new(string name = "dma_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction:new

endclass: dma_sequencer
class dma_test extends uvm_test;

    `uvm_component_utils(dma_test)
    dma_env env_h;
    reg_sequence seq;

    function new(string name = "dma_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    function void end_of_elaboration(uvm_phase phase);
        super.end_of_elaboration(phase);
        uvm_top.print_topology();
    endfunction: end_of_elaboration

    task run_phase(uvm_phase phase);

        forever begin
            seq = reg_sequence::type_id::create("seq");
            phase.raise_objection(this);
            seq.start(env_h.agt_h.sqr_h);
            phase.drop_objection(this);
        end
    endtask: run_phase

endclass: dma_test


`include "uvm_macros.svh"
`include "uvm_pkg.sv"

package dma_pkg;

import uvm_pkg::*;

    `include "dma_seq_item.sv"

    `include "reg_intr.sv"
    `include "reg_ctrl.sv"
    `include "reg_io_addr.sv"
    `include "reg_mem_addr.sv"
    `include "reg_extra_info.sv"
    `include "reg_status.sv"
    `include "reg_transfer_count.sv"
    `include "reg_descriptor_addr.sv"
    `include "reg_error_status.sv"
    `include "reg_config.sv"

    `include "dma_reg_block.sv"
    `include "reg_adapter.sv"
    `include "reg_sequence.sv"
    `include "reg_predictor.sv"
    `include "dma_sequencer.sv"

    `include "dma_driver.sv"
    `include "dma_monitor.sv"
    `include "dma_agent.sv"
    `include "dma_env.sv"
    `include "dma_test.sv"
endpackage

class reg_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg_adapter);

    function new(string name = "reg_adapter");
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

        rw.kind = tr.wr_en ? UVM_WRITE : UVM_READ;
        rw.addr = tr.addr;
        rw.data = tr.rdata;
        rw.status = UVM_IS_OK;

    endfunction: bus2reg

endclass: reg_adapter

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
			bins priority_bins[] = {0,1,2,3};
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
		cp_data_width: coverpoint data_width.value[7:4]{
			bins min = {0};
			bins max = {4'hF};
			bins other_vals = {[4'h1 : 4'hE]};
		}
		cp_descriptor_mode: coverpoint descriptor_mode.value[8]{
			bins min = {0};
			bins max = {1};
		}
		cp_reserved: coverpoint reserved.value[31:9]{
			bins min = {0};
			bins max = {23'h7F_FFFF};
			bins other_vals = {[23'h1 : 23'h7F_FFFE]};
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
        cp_mask: coverpoint w_count.value[15:1] {
            bins min = {0};
            bins max = {15'h7FFF};
            bins other_vals = {[15'h1 : 15'h7FFE]};
        }
        cp_io_mem: coverpoint io_mem.value[16]{
            bins min = {0};
            bins max = {1};
        }
        cp_reserved: coverpoint reserved.value[31:17] {
            bins min = {0};
            bins max = {15'h7FFF};
            bins other_vals = {[15'h1 : 15'h7FFE]};
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
    
endclass


class reg_descriptor_addr extends uvm_reg;
	`uvm_object_utils(reg_descriptor_addr)
	rand uvm_reg_field descriptor_addr;	//rw
	
	covergroup cg_descriptor_addr;
		cp_status: coverpoint descriptor_addr.value[31:0]{
			bins min = {0};
			bins max = {32'hFFFF_FFFF};
			bins other_vals = {[32'h1 : 32'hFFFF_FFFE]};
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

class reg_error_status extends uvm_reg;
	`uvm_object_utils(reg_error_status)
	rand uvm_reg_field bus_error;			//rw1c
	rand uvm_reg_field timeout_error;		//rw1c
	rand uvm_reg_field alignment_error;		//rw1c
	rand uvm_reg_field overflow_error;		//rw1c
	rand uvm_reg_field underflow_error;		//rw1c
	rand uvm_reg_field reserved;			//ro
	rand uvm_reg_field error_code;			//ro
	rand uvm_reg_field error_addr_offset; 	//ro
	
	covergroup cg_error_status;
		cp_bus_error: coverpoint bus_error.value[0]{
			bins min = {0};
			bins max = {1};
			}
		cp_timeout_error: coverpoint timeout_error.value[1]{
			bins min = {0};
			bins max = {1};
		}
		cp_alignment_error: coverpoint alignment_error.value[2]{
			bins min = {0};
			bins max = {1};
		}
		cp_overflow_error: coverpoint overflow_error.value[3]{
			bins min = {0};
			bins max = {1};
		}
		cp_underflow_error: coverpoint underflow_error.value[4]{
			bins min = {0};
			bins max = {1};
		}
		cp_reserved: coverpoint reserved.value[7:5]{
			bins reserved_bins = {[0:7]};
		}
		
		cp_error_code: coverpoint error_code.value[15:8]{
			bins min = {0};
			bins max = {8'hFF};
			bins other_vals = {[8'h1 : 8'hFE]};
		}
		cp_error_addr_offset: coverpoint error_addr_offset.value[31:16]{
			bins min = {0};
			bins max = {16'hFFFF};
			bins other_vals = {[16'h1 : 16'hFFFE]};
		}
		
		endgroup: cg_error_status
	
	function new(string name = "reg_error_status");
		super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS)) 
			cg_error_status = new();
	endfunction: new
	
	virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
		cg_error_status.sample();
	endfunction: sample
	virtual function void sample_values();
		super.sample_values();
		cg_error_status.sample();
	endfunction: sample_values
	
	function void build();
		bus_error = uvm_reg_field::type_id::create("bus_error");
		bus_error.configure( .parent(this), .size(1), .lsb_pos(0), .access("RW1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

		timeout_error = uvm_reg_field::type_id::create("timeout_error");
		timeout_error.configure( .parent(this), .size(1), .lsb_pos(1), .access("RW1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

		alignment_error = uvm_reg_field::type_id::create("alignment_error");
		alignment_error.configure( .parent(this), .size(1), .lsb_pos(2), .access("RW1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

		overflow_error = uvm_reg_field::type_id::create("overflow_error");
		overflow_error.configure( .parent(this), .size(1), .lsb_pos(3), .access("RW1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

		underflow_error = uvm_reg_field::type_id::create("underflow_error");
		underflow_error.configure( .parent(this), .size(1), .lsb_pos(4), .access("RW1C"), .volatile(0), .reset(0), .has_reset(1), .is_rand(1), .individually_accessible(1));

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure( .parent(this), .size(3), .lsb_pos(5), .access("RO"), .volatile(1), .reset(3'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		error_code = uvm_reg_field::type_id::create("error_code");
		error_code.configure( .parent(this), .size(8), .lsb_pos(8), .access("RO"), .volatile(1), .reset(8'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

		error_addr_offset = uvm_reg_field::type_id::create("error_addr_offset");
		error_addr_offset.configure( .parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(1), .reset(16'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));


	endfunction
	
endclass: reg_error_status

class reg_extra_info extends uvm_reg;
	`uvm_object_utils(reg_extra_info)
	rand uvm_reg_field extra_info;	//rw
	
	covergroup cg_extra_info;
		cp_status: coverpoint extra_info.value[31:0]{
			bins min = {0};
			bins max = {32'hFFFF_FFFF};
			bins other_vals = {[32'h1 : 32'hFFFF_FFFE]};
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

class reg_intr extends uvm_reg;
    `uvm_object_utils(reg_intr)
    rand uvm_reg_field intr_status; //ro
    rand uvm_reg_field intr_mask;   //ro
    
    covergroup cg_intr;
        cp_status: coverpoint intr_status.value[15:0]{
            bins min = {0};
            bins max = {16'hFFFF};
            bins other_vals = {[16'h1 : 16'hFFFE]};
        }
        cp_mask: coverpoint intr_mask.value[15:0] {
            bins min = {0};
            bins max = {16'hFFFF};
            bins other_vals = {[16'h1 : 16'hFFFE]};
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
        intr_mask.configure(    .parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(1), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1)  );
        
    endfunction

endclass


class reg_io_addr extends uvm_reg;
	`uvm_object_utils(reg_io_addr)
	rand uvm_reg_field io_addr;	//rw
	
	covergroup cg_io_addr;
		cp_status: coverpoint io_addr.value[31:0]{
			bins min = {0};
			bins max = {32'hFFFF_FFFF};
			bins other_vals = {[32'h1 : 32'hFFFF_FFFE]};
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

class reg_mem_addr extends uvm_reg;
	`uvm_object_utils(reg_mem_addr)
	rand uvm_reg_field mem_addr;	//rw
	
	covergroup cg_mem_addr;
		cp_status: coverpoint mem_addr.value[31:0]{
			bins min = {0};
			bins max = {32'hFFFF_FFFF};
			bins other_vals = {[32'h1 : 32'hFFFF_FFFE]};
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
		mem_addr.configure(	.parent(this), .size(32), .lsb_pos(0), .access("RW"), .volatile(0), .reset(32'h0), .has_reset(1), .is_rand(1), .individually_accessible(1)	);

	endfunction
	
endclass: reg_mem_addr

class reg_sequence extends uvm_sequence #(uvm_reg_item);
    `uvm_object_utils(reg_sequence)

    dma_reg_block  top_reg_h;
    uvm_status_e   status;
    uvm_reg_data_t rdata;

    function new(string name = "reg_sequence");
        super.new(name);
    endfunction

    task body();

        // 1. INTR_REG ro
        top_reg_h.intr_h.write(status, 32'hAAAA_AAAA);
        top_reg_h.intr_h.read(status, rdata);

        // 2. CTRL REG rw

        top_reg_h.ctrl_h.write(status, 32'h1234_1234);
        top_reg_h.ctrl_h.read(status, rdata);

        // 3. IO_ADDR rw
        top_reg_h.io_addr_h.write(status, 32'h1024_040C);
        top_reg_h.io_addr_h.read(status, rdata);

        // 4. MEM_ADDR rw
        top_reg_h.mem_addr_h.write(status, 32'hABCD_EF00);
        top_reg_h.mem_addr_h.read(status, rdata);

        // 5. EXTRA_INFO rw
        top_reg_h.extra_info_h.write(status, 32'h1122_1122);
        top_reg_h.extra_info_h.read(status, rdata);

        // 6. STATUS ro
        top_reg_h.status_h.write(status, 32'hABCD_0001);
        top_reg_h.status_h.read(status, rdata);

        // 7. TRANSFER_COUNT ro
        top_reg_h.transfer_count_h.write(status, 32'h5555_5555);
        top_reg_h.transfer_count_h.read(status, rdata);

        // 8. DESCRIPTOR_ADDR ro
        top_reg_h.descriptor_addr_h.write(status, 32'hA5A5_A5A5);
        top_reg_h.descriptor_addr_h.read(status, rdata);

        // 9. ERROR_STATUS rw1c
        top_reg_h.error_status_h.write(status, 32'h1234_ABCD);
        top_reg_h.error_status_h.read(status, rdata);

        // 10. CONFIG rw
        top_reg_h.config_h.write(status, 32'hA1B2_C3D4);
        top_reg_h.config_h.read(status, rdata);

    endtask: body
endclass

class reg_status extends uvm_reg;
	`uvm_object_utils(reg_status)
	rand uvm_reg_field busy;	//ro
	rand uvm_reg_field done;	//ro
	rand uvm_reg_field error;	//ro
	rand uvm_reg_field paused;	//ro
	rand uvm_reg_field current_state;	//ro
	rand uvm_reg_field fifo_level;		//ro
	rand uvm_reg_field reserved;		//ro
	
	covergroup cg_status;
		cp_busy: coverpoint busy.value[0]{
			bins min = {0};
			bins max = {1};
		}
		cp_done: coverpoint done.value[1]{
			bins min = {0};
			bins max = {1};
		}
		cp_error: coverpoint error.value[2]{
			bins min = {0};
			bins max = {1};
		}
		cp_paused: coverpoint paused.value[3]{
			bins min = {0};
			bins max = {1};
		}
		cp_current_state: coverpoint current_state.value[7:4]{
			bins min = {0};
			bins max = {4'hF};
			bins other_vals = {[4'h1 : 4'hE]};
		}
		cp_fifo_level: coverpoint fifo_level.value[0]{
			bins min = {0};
			bins max = {8'hFF};
			bins other_vals = {[8'h1 : 8'hFE]};
		}
		cp_reserved: coverpoint reserved.value[0]{
			bins min = {0};
			bins max = {16'hFFFF};
			bins other_vals = {[16'h1 : 16'hFFFE]};
		}
		
		endgroup: cg_status
	
	function new(string name = "reg_status");
		super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS)) 
			cg_status = new();
	endfunction: new
	
	virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
		cg_status.sample();
	endfunction: sample
	virtual function void sample_values();
		super.sample_values();
		cg_status.sample();
	endfunction: sample_values
	
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

class reg_transfer_count extends uvm_reg;
	`uvm_object_utils(reg_transfer_count)
	rand uvm_reg_field transfer_count;	//ro
	
	covergroup cg_transfer_count;
		cp_status: coverpoint transfer_count.value[31:0]{
			bins min = {0};
			bins max = {32'hFFFF_FFFF};
			bins other_vals = {[32'h1 : 32'hFFFF_FFFE]};
		}
		endgroup: cg_transfer_count
	
	function new(string name = "reg_transfer_count");
		super.new(name, 32, UVM_CVR_FIELD_VALS);
		if(has_coverage(UVM_CVR_FIELD_VALS)) 
			cg_transfer_count= new();
	endfunction: new
	
	virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
		cg_transfer_count.sample();
	endfunction: sample
	virtual function void sample_values();
		super.sample_values();
		cg_transfer_count.sample();
	endfunction: sample_values
	
	function void build();
		transfer_count = uvm_reg_field::type_id::create("transfer_count");
		transfer_count.configure(	.parent(this), .size(32), .lsb_pos(0), .access("RO"), .volatile(1), .reset(32'h0), .has_reset(1), .is_rand(0), .individually_accessible(1)	);

	endfunction
	
endclass: reg_transfer_count

`include "uvm_macros.svh"
`include "uvm_pkg.sv"
`include "dma_intf.sv"

module top;
    import uvm_pkg::*;

    bit clk, rst_n;
    dma_intf intf(clk, rst_n);

    // dut instance
//	ral_dut dut(.clk(clk), .rst_n(intf.rst_n), .wr_en(intf.wr_en), .rd_en(intf.rd_en), .wdata(intf.wdata), .addr(intf.addr), .rdata(intf.rdata));
/*    
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst_n = 0;

        #10 rst_n = 1;
    end
*/
    initial begin
  //      uvm_config_db#(virtual dma_intf)::set(null, "*", "vif", intf);
        run_test();
    end

endmodule

