package reset_seq_pkg;
import uvm_pkg::*;
//import shared_pkg::*;
import sequence_item_pkg::*;
`include "uvm_macros.svh"

class reset_seq extends uvm_sequence #(sequence_item);
`uvm_object_utils(reset_seq)
sequence_item sq_item;

function new(string name = "reset_seq");
super.new();
endfunction

task body;

sq_item = sequence_item::type_id::create("sq_item");
start_item(sq_item);
sq_item.rst_n = 0;
sq_item.MOSI = 0;
sq_item.SS_n= 0;
sq_item.tx_valid = 0;
sq_item.tx_data = 0;
finish_item(sq_item);

endtask

endclass

endpackage