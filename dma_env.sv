class dma_env extends uvm_env;
    `uvm_component_utils(dma_env)
    dma_agent agt_h;
    dma_reg_block top_reg_h;
    dma_adapter adapter_h;
    dma_predictor#(dma_seq_item) predictor_h;

    //    uvm_reg_predictor#(dma_seq_item) predictor_h;


    function new(string name = "dma_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt_h = dma_agent::type_id::create("agt_h", this);
		//predictor
        predictor_h = dma_predictor#(dma_seq_item)::type_id::create("predictor_h", this);

		// register top block
        top_reg_h = dma_reg_block::type_id::create("top_reg_h", this);
        top_reg_h.build();
        top_reg_h.lock_model();

        //adapter
        adapter_h = dma_adapter::type_id::create("adapter_h", this);


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

