package write_only_sequence;
import RAM_sequence_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class write_only_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(write_only_seq)
   RAM_seq_item item;
    function new(string name = "write_only_seq");
        super.new(name);
    endfunction //new()

    task body();
        item = RAM_seq_item::type_id::create("item");
        item.read_only.constraint_mode(0);
        item.read_write.constraint_mode(0);
        
        repeat(20000) begin
            start_item(item);
            // write the sequence
            item.randomize();
            finish_item(item);
        end
    endtask 
endclass //main_seq extends uvm_sequence
endpackage