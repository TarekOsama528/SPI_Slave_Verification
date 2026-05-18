module SVA (SPI_if.SVA_mp vif);

always_comb begin
if (!vif.rst_n) begin
a_reset: assert final (vif.MISO == 1'b0 && vif.rx_data == 8'h0 && vif.rx_valid == 1'b0);
cover final (vif.MISO == 1'b0 && vif.rx_data == 8'h0 && vif.rx_valid == 1'b0);
end
end
endmodule