package RAM_sequence_item;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_seq_item extends uvm_sequence_item;
        `uvm_object_utils(RAM_seq_item)
        function new(string name = "RAM_seq_item");
            super.new(name);
        endfunction
        // define variables and constraints

        rand bit rst_n;
        rand bit [9:0] din;
        rand bit rx_valid;
        rand bit [1:0] prev_mode, current_mode;

        bit [7:0] dout, dout_ref; // This variable is not randomized as it will be driven by the DUT (RAM) and monitored by the testbench
        bit tx_valid, tx_valid_ref; // This variable is not randomized as it will be driven by the DUT (RAM) and monitored by the testbench

        //din[9:8] == 2 'b00 write address 
        //din[9:8] == 2 'b01 write data
        //din[9:8] == 2 'b10 read address
        //din[9:8] == 2 'b11 read data

        constraint c1 {rst_n dist {1:=98, 0:=2};} // 98% chance of being 1 (not reset), 2% chance of being 0 (reset)
        constraint c2 {rx_valid dist {1:=90, 0:=10};} // 90% chance of being 1 (valid), 10% chance of being 0 (not valid)
        constraint write_only {if (prev_mode==2'b00) din[9:8] inside {[0:1]};}
        constraint c3 {current_mode == din[9:8];}
        constraint read_only {if (prev_mode==2'b10) din[9:8] == 2'b11; else if (prev_mode==2'b11) din[9:8] == 2'b10;}

        constraint read_write {
            if (prev_mode == 2'b00) {
                din[9:8] inside {[0:1]}; // After a write address, we can have either a write data or another write address
            }
            else if (prev_mode == 2'b01) {
                din[9:8] dist {0:=40, 2:=60}; // After a write data, we can have either a write address (40% chance) or a read address (60% chance)
            }
            else if (prev_mode == 2'b10) {
                din[9:8] == 2'b11; // After a read address, we have read data
            }
            else if (prev_mode == 2'b11) {
                din[9:8] dist {0:=60, 2:=40}; // After a read data, we can have either a write address (60% chance) or a read address (40% chance)
            }
        }

        function void post_randomize();
            prev_mode = current_mode;
        endfunction


        
    endclass //seq_item extends superClass
endpackage