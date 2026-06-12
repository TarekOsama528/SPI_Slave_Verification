package reset_sequence;
import RAM_sequence_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class reset_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(reset_seq)
   RAM_seq_item item;
    function new(string name = "reset_seq");
        super.new(name);
    endfunction //new()

    task body();
        item =RAM_seq_item::type_id::create("item");
        start_item(item);
        // write the sequence
        item.randomize() with {
            rst_n == 0;   // assert reset
        };
        finish_item(item);
    endtask 
endclass //main_seq extends uvm_sequence
endpackage