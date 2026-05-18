package SPI_driver_pkg;
import SPI_config_pkg::*;
import sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(SPI_driver)  // Added parentheses around class name

  virtual SPI_if vif;
  SPI_config cfg;
  sequence_item stim_seq_item;

  function new (string name="SPI_driver",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(SPI_config)::get(this,"","CFG",cfg)) begin  // Fixed type parameter
        `uvm_fatal("DRIVER","unable to get config object")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
        stim_seq_item = sequence_item::type_id::create("stim_seq_item");
        seq_item_port.get_next_item(stim_seq_item);
        vif.MOSI= stim_seq_item.MOSI;
        vif.tx_valid = stim_seq_item.tx_valid;
        vif.tx_data = stim_seq_item.tx_data;
        vif.rst_n = stim_seq_item.rst_n;
        vif.SS_n = stim_seq_item.SS_n;
        @(negedge vif.clk);
        seq_item_port.item_done();
        `uvm_info("run_phase",stim_seq_item.convert2string(),UVM_HIGH); 
    end
  endtask

endclass

endpackage