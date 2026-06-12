module RAM_ref (RAM_if.REF ram_if);

reg [ram_if.ADDR_SIZE - 1 : 0] MEM [ram_if.MEM_DEPTH - 1 : 0];

reg [ram_if.ADDR_SIZE - 1 : 0] Rd_Addr, Wr_Addr;

always @(posedge ram_if.clk) begin
    if (~ram_if.rst_n) begin
        ram_if.dout_ref <= 0;
        ram_if.tx_valid_ref <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else begin                                         
        if (ram_if.rx_valid) begin
            case (ram_if.din[9:8])
                2'b00 : Wr_Addr <= ram_if.din[7:0];
                2'b01 : MEM[Wr_Addr] <= ram_if.din[7:0];
                2'b10 : Rd_Addr <= ram_if.din[7:0];
                2'b11 : ram_if.dout_ref <= MEM[Rd_Addr];
                default : ram_if.dout_ref <= 0;
            endcase
        end
        ram_if.tx_valid_ref <= (ram_if.din[9] && ram_if.din[8] && ram_if.rx_valid)? 1'b1 : 1'b0;
    end 
end
endmodule