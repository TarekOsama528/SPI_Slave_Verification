package monitor_pkg;
import uvm_pkg::*;
//import shared_pkg::*;
import sequence_item_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)

virtual SPI_if vif;
sequence_item seq_item;
uvm_analysis_port #(sequence_item) ap;

function new(string name="monitor", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
    seq_item = sequence_item::type_id::create("seq_item");
    @(negedge vif.clk);
    seq_item.rst_n = vif.rst_n;
    seq_item.tx_valid = vif.tx_valid;
    seq_item.tx_data = vif.tx_data;
    seq_item.MOSI = vif.MOSI;
    seq_item.SS_n = vif.SS_n;
    seq_item.MISO = vif.MISO;
    seq_item.rx_data = vif.rx_data;
    seq_item.rx_valid = vif.rx_valid;
    
    seq_item.rx_data_ref = vif.rx_data_ref;
    seq_item.MISO_ref = vif.MISO_ref;
    seq_item.rx_valid_ref = vif.rx_valid_ref;
    ap.write(seq_item);
    `uvm_info("run_phase",seq_item.convert2string(),UVM_HIGH);
end
endtask
endclass

endpackage