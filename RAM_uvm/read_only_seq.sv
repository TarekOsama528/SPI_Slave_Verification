package read_only_sequence;
import RAM_sequence_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class read_only_seq extends uvm_sequence#(RAM_seq_item);
    `uvm_object_utils(read_only_seq)
   RAM_seq_item item;
    function new(string name = "read_only_seq");
        super.new(name);
    endfunction //new()

    task body();
        item = RAM_seq_item::type_id::create("item");
        item.write_only.constraint_mode(0);
        item.read_write.constraint_mode(0);
        repeat(1000) begin
        start_item(item);

        // write the sequence
        finish_item(item);
        item.randomize();
        end
        
    endtask 
endclass //main_seq extends uvm_sequence
endpackage