import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;

module top();
  // Clock generation
  bit clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Instantiate the interface and DUT
  SPI_if SPI_if_inst(clk);
  SLAVE dut(
    .clk(clk),
    .MOSI(SPI_if_inst.MOSI),
    .rst_n(SPI_if_inst.rst_n),
    .SS_n(SPI_if_inst.SS_n),
    .tx_valid(SPI_if_inst.tx_valid),
    .tx_data(SPI_if_inst.tx_data),
    .MISO(SPI_if_inst.MISO),
    .rx_valid(SPI_if_inst.rx_valid),
    .rx_data(SPI_if_inst.rx_data)
  );

  golden_model ref_model(
    .clk(clk),
    .MOSI(SPI_if_inst.MOSI),
    .rst_n(SPI_if_inst.rst_n),
    .SS_n(SPI_if_inst.SS_n),
    .tx_valid(SPI_if_inst.tx_valid),
    .tx_data(SPI_if_inst.tx_data),
    .MISO(SPI_if_inst.MISO_ref),
    .rx_valid(SPI_if_inst.rx_valid_ref),
    .rx_data(SPI_if_inst.rx_data_ref)
  );

  bind SLAVE SVA SVA_inst(.vif(SPI_if_inst.SVA_mp));

  initial begin
    // Set the virtual interface for the uvm test
    uvm_config_db#(virtual SPI_if)::set(null, "*", "vif", SPI_if_inst);
    run_test("SPI_test");
  end

endmodule