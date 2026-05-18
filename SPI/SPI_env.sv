package SPI_env_pkg;
import uvm_pkg::*;
import SPI_config_pkg::*;
import agent_pkg::*;
import scoreboard_pkg::*;
import cover_collect_pkg::*;
`include "uvm_macros.svh"

class SPI_env extends uvm_env;
  // Example 1
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(SPI_env)

  agent agt;
  scoreboard sb;
  cover_collect cc;

  function new(string name = "SPI_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt",this);
    sb = scoreboard::type_id::create("sb",this);
    cc = cover_collect::type_id::create("cc",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.ap.connect(sb.sb_export);
    agt.ap.connect(cc.cov_export);
  endfunction
  
endclass
endpackage