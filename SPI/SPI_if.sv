//import shared_pkg::*;
interface SPI_if (clk);
  input clk;
  logic rst_n,tx_valid,rx_valid,MISO,MOSI,SS_n;
  logic [7:0] tx_data;
  logic [9:0] rx_data;
  
  logic [9:0] rx_data_ref;
  logic MISO_ref;
  logic rx_valid_ref;

  modport SVA_mp (
        input   clk, MOSI, rst_n, SS_n, tx_valid, tx_data,
        input   MISO, rx_valid, rx_data  // SVA monitors all signals
    );
endinterface : SPI_if