package agent_pkg;
import uvm_pkg::*;
import sequence_item_pkg::*;
import SPI_driver_pkg::*;
import monitor_pkg::*;
import SPI_config_pkg::*;
import sequencer_pkg::*;
`include "uvm_macros.svh"

class agent extends uvm_agent;
`uvm_component_utils(agent)

sequencer sqr;
SPI_driver driver;
monitor mon;
SPI_config cfg;
uvm_analysis_port #(sequence_item) ap;

function new (string name = "agent",uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db #(SPI_config)::get(this,"","CFG",cfg))
    `uvm_fatal("build_phase","unable to get config object")

    sqr = sequencer::type_id::create("sqr",this);
    driver = SPI_driver::type_id::create("driver",this);
    mon = monitor::type_id::create("mon",this);
    ap = new("ap",this);

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
driver.vif = cfg.vif;
mon.vif = cfg.vif;
driver.seq_item_port.connect(sqr.seq_item_export);
mon.ap.connect(ap);

endfunction


endclass
endpackage