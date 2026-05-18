package SPI_test_pkg;
import SPI_env_pkg::*;
import SPI_config_pkg::*;
import reset_seq_pkg::*;
import main_seq_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_test extends uvm_test;
    `uvm_component_utils(SPI_test)

    SPI_config cfg;
    SPI_env my_env;
    main_seq main_sequence;
    reset_seq reset_sequence;

  // Example 1
  // Do the essentials (factory register & Constructor)
  // Build the enviornment in the build phase
  function new(string name = "SPI_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    my_env = SPI_env::type_id::create("my_env", this);
    main_sequence = main_seq::type_id::create("main_sequence");
    reset_sequence = reset_seq::type_id::create("reset_sequence");

    // Build the config object in the build phase
    cfg = SPI_config::type_id::create("cfg");
    
    // get the virtual interface and assign it to the virtual interface of the config object
    if(!uvm_config_db#(virtual SPI_if)::get(this, "", "vif", cfg.vif)) begin
      `uvm_error("NOVIF", "Virtual interface not found")
    end
    
    // set the config obj in the config db
    uvm_config_db#(SPI_config)::set(this, "*", "CFG", cfg);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("TEST", "Starting SPI test", UVM_LOW)
    reset_sequence.start(my_env.agt.sqr);
    `uvm_info("TEST", "Reset sequence completed", UVM_LOW)

    `uvm_info("TEST", "Starting main sequence", UVM_LOW)
    main_sequence.start(my_env.agt.sqr);
    `uvm_info("TEST", "Main sequence completed", UVM_LOW)
    phase.drop_objection(this);
  endtask
  
endclass: SPI_test
endpackage