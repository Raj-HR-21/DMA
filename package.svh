
`include "uvm_macros.svh"

package dma_pkg;

import uvm_pkg::*;

    `include "dma_seq_item.sv"

    `include "dma_reg.sv"
    `include "dma_regblock.sv"
    `include "dma_adapter.sv"

    `include "dma_sequencer.sv"
    `include "dma_driver.sv"
    `include "dma_monitor.sv"
    `include "dma_agent.sv"
    `include "dma_predictor.sv"

    `include "seq.sv"
    `include "dma_env.sv"
    `include "dma_test.sv"

endpackage

