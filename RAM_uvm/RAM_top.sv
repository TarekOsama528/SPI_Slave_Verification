import RAM_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();
    bit clk ;
    initial begin
        forever begin
            #1;
            clk=!clk;
        end
    end
    RAM_if RAM_test_vif(clk);
    RAM dut (RAM_test_vif);
    RAM_ref reference_model (RAM_test_vif);

    bind RAM sva sva_inst(RAM_test_vif.SVA_mp);
    initial begin
    uvm_config_db#(virtual RAM_if)::set(null,"*","RAM_test_vif",RAM_test_vif);
    run_test("RAM_test");
    end

endmodule