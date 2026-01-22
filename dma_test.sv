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
    task run_phase(uvm_phase phase);

        seq = reg_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.top_reg_h = env_h.top_reg_h;
        seq.start(env_h.agt_h.sqr_h);
        phase.drop_objection(this);
    endtask: run_phase

endclass: dma_test

