package RAM_sequencer;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_sequence_item::*;

class RAM_sqr_class extends uvm_sequencer #(RAM_seq_item);
    `uvm_component_utils(RAM_sqr_class)

    function new(string name = "RAM_sqr_class" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass 
    
endpackage