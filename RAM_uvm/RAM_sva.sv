import uvm_pkg::*;
`include "uvm_macros.svh"

module sva (RAM_if.SVA_mp ram_if);
//assertions 


    property reset;
    @(posedge ram_if.clk) (!ram_if.rst_n |=> (ram_if.dout == 8'b0) && (ram_if.tx_valid == 0));
    endproperty

    assert_reset : assert property (reset);
    cover_reset : cover property (reset);

    property tx_valid_low_ass;
        @(posedge ram_if.clk) 
            ((ram_if.din[9:8] == 2'b00) || (ram_if.din[9:8] == 2'b01) || (ram_if.din[9:8] == 2'b10)) |=> (ram_if.tx_valid == 0);
    endproperty

    property tx_valid_after_read;
        @(posedge ram_if.clk) disable iff (!ram_if.rst_n)
            (ram_if.din[9:8] == 2'b11 && ram_if.rx_valid) |=> 
             (ram_if.tx_valid == 1) ##[1:$] (ram_if.tx_valid == 0);  
    endproperty

    property write_addr_followed_by_data;
        @(posedge ram_if.clk) disable iff (!ram_if.rst_n)
            (ram_if.din[9:8] == 2'b00) |=> ##[1:$] (ram_if.din[9:8] == 2'b01);
    endproperty

    property read_addr_followed_by_data;
        @(posedge ram_if.clk) disable iff (!ram_if.rst_n)
            (ram_if.din[9:8] == 2'b10) |=> ##[1:$] (ram_if.din[9:8] == 2'b11);
    endproperty

    tx_valid_low_ass_p :assert property (tx_valid_low_ass);
    tx_valid_after_read_p :assert property (tx_valid_after_read);
    write_addr_followed_by_data_p :assert property (write_addr_followed_by_data);
    read_addr_followed_by_data_p :assert property (read_addr_followed_by_data);

    tx_valid_low_ass_cov :cover property (tx_valid_low_ass);
    tx_valid_after_read_cov :cover property (tx_valid_after_read);
    write_addr_followed_by_data_cov :cover property (write_addr_followed_by_data);
    read_addr_followed_by_data_cov :cover property (read_addr_followed_by_data);
    endmodule