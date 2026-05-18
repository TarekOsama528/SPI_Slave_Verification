package SPI_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_config extends uvm_object;
  virtual SPI_if vif;
  `uvm_object_utils(SPI_config)
  
  function new(string name = "SPI_config");
    super.new(name);
  endfunction
endclass



endpackage