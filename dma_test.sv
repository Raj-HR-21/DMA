class reset_test extends uvm_test;
    `uvm_component_utils(reset_test)
    dma_env env_h;
    reset_seq seq;

    function new(string name = "reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        seq = reset_seq::type_id::create("seq", this);

        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: reset_test 

// --------------------------------------------------------
class dma_test_1 extends uvm_test;

    `uvm_component_utils(dma_test_1)
    dma_env env_h;
    reg_seq_1 seq;

    function new(string name = "dma_test_1", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = reg_seq_1::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: dma_test_1

// --------------------------------------------------------
class intr_test extends uvm_test;

    `uvm_component_utils(intr_test)
    dma_env env_h;
    intr_seq seq;

    function new(string name = "intr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = intr_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: intr_test

// --------------------------------------------------------
class ctrl_test extends uvm_test;
    `uvm_component_utils(ctrl_test)
    dma_env env_h;
    ctrl_seq seq;

    function new(string name = "ctrl_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = ctrl_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: ctrl_test

// --------------------------------------------------------
class io_addr_test extends uvm_test;

    `uvm_component_utils(io_addr_test)
    dma_env env_h;
    io_addr_seq seq;

    function new(string name = "io_addr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = io_addr_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: io_addr_test

// --------------------------------------------------------
class mem_addr_test extends uvm_test;
    `uvm_component_utils(mem_addr_test)
    dma_env env_h;
    mem_addr_seq seq;

    function new(string name = "mem_addr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = mem_addr_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: mem_addr_test

// --------------------------------------------------------
class extra_info_test extends uvm_test;

    `uvm_component_utils(extra_info_test)
    dma_env env_h;
    extra_info_seq seq;

    function new(string name = "extra_info_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = extra_info_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: extra_info_test

// --------------------------------------------------------
class status_test extends uvm_test;

    `uvm_component_utils(status_test)
    dma_env env_h;
    status_seq seq;

    function new(string name = "status_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = status_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: status_test

// --------------------------------------------------------
class transfer_count_test extends uvm_test;

    `uvm_component_utils(transfer_count_test)
    dma_env env_h;
    transfer_count_seq seq;

    function new(string name = "transfer_count_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = transfer_count_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: transfer_count_test

// --------------------------------------------------------
class descriptor_addr_test extends uvm_test;

    `uvm_component_utils(descriptor_addr_test)
    dma_env env_h;
    descriptor_addr_seq seq;

    function new(string name = "descriptor_addr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = descriptor_addr_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: descriptor_addr_test

// --------------------------------------------------------
class error_status_test extends uvm_test;

    `uvm_component_utils(error_status_test)
    dma_env env_h;
    error_status_seq seq;

    function new(string name = "error_status_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = error_status_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: error_status_test

// --------------------------------------------------------
class config_test extends uvm_test;

    `uvm_component_utils(config_test)
    dma_env env_h;
    config_seq seq;

    function new(string name = "config_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);

    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = config_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: config_test
// --------------------------------------------------------
class regression_test extends uvm_test;

    `uvm_component_utils(regression_test)
    dma_env env_h;
    regression_seq seq;
    function new(string name = "regression_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = regression_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase
endclass: regression_test
// --------------------------------------------------------
class sample_test extends uvm_test;

    `uvm_component_utils(sample_test)
    dma_env env_h;
    sample_seq seq;
    function new(string name = "sample_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = dma_env::type_id::create("env_h", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        seq = sample_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase
endclass: sample_test

// --------------------------------------------------------


