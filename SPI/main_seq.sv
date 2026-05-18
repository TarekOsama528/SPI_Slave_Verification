package main_seq_pkg;
import uvm_pkg::*;
//import shared_pkg::*;
import sequence_item_pkg::*;
`include "uvm_macros.svh"

class main_seq extends uvm_sequence #(sequence_item);
`uvm_object_utils(main_seq)

sequence_item sq_item;

function new(string name = "main_seq");
super.new();
endfunction

task body;

sq_item = sequence_item::type_id::create("sq_item");

repeat(10000) begin
start_item(sq_item);
assert(sq_item.randomize());
finish_item(sq_item);
end

endtask

endclass

endpackage