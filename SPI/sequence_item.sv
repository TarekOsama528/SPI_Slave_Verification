package sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class sequence_item extends uvm_sequence_item;
`uvm_object_utils(sequence_item)

rand logic MOSI;
rand logic SS_n;
rand logic tx_valid;
rand logic [7:0] tx_data;
rand bit rst_n;

logic rx_valid,rx_valid_ref;
logic [9:0] rx_data,rx_data_ref;
logic MISO,MISO_ref;

rand bit [10:0] mosi_array;  // 11-bit randomized array
int cycle_count = 0,read_data_cycle=0,cases_cycle=0;         // Cycle counter for SS_n timing
bit generate_new_array; // Flag to indicate when to generate a new array

function new(string name = "sequence_item");
super.new(name);
endfunction

//000 (Write Address)
//001 (Write Data)
//110 (Read Address)
//111 (Read Data)

constraint c1 {rst_n dist {1:=95, 0:=5};}
// Constraint 4: tx_valid high in case of read data
constraint c2 {tx_valid == (mosi_array[2:0]==3'b111);}

// Constraint for valid first 3 bits (applied during SS_n falling edge)
constraint valid_first_3_bits {
    // This constraint ensures that when SS_n falls, the first 3 bits are valid
    // The actual application timing would be handled in the driver/sequence
    if (!SS_n) mosi_array[2:0] inside {3'b000, 3'b001, 3'b110, 3'b111};
}

constraint array_regeneration {
    // Array gets new random values
    foreach (mosi_array[i]) {
        mosi_array[i] inside {[0:1]};
    }
}
    function void pre_randomize();
        // Determine if we need new array
        generate_new_array = (cycle_count % 11 == 0);
        // Control array randomization
        if (generate_new_array) begin
            mosi_array.rand_mode(1);  // Enable array randomization
            //$display("Generating NEW array at cycle %0d", cycle_count);
        end else begin
            mosi_array.rand_mode(0);  // Keep existing array values
            //$display("Reusing array at cycle %0d, index %0d", cycle_count, cycle_count % 11);
        end
    endfunction

// Post-randomize for points 2 and 3
function void post_randomize();
    // Point 3: Drive MOSI from the randomized array
    MOSI = mosi_array[cycle_count % 11];
    // Point 2: SS_n timing based on operation type
    if ((mosi_array[2:0]==3'b111)) begin
        // Read data: SS_n high for one cycle every 23 cycles
        SS_n = (read_data_cycle % 23 == 0) ? 1'b1 : 1'b0;
    end else begin
        // All other cases: SS_n high for one cycle every 13 cycles
        SS_n = (cases_cycle % 13 == 0) ? 1'b1 : 1'b0;
    end
    // Increment cycle counter for next transaction
    cycle_count++;
    if ((mosi_array[2:0]==3'b111)) read_data_cycle++;
    else cases_cycle++;
endfunction

function string convert2string();
return $sformatf("%s rst_n=%b tx_valid=%d MOSI=%b tx_data=%b SS_n=%d rx_data=%b MISO=%d",super.convert2string(),rst_n,tx_valid,MOSI,tx_data,SS_n,rx_data,MISO);
endfunction
function string convert2string_stimulus();
return $sformatf("rst_n=%b tx_valid=%d MOSI=%b tx_data=%b SS_n=%d rx_data=%b MISO=%d",rst_n,tx_valid,MOSI,tx_data,SS_n,rx_data,MISO);
endfunction
endclass
endpackage