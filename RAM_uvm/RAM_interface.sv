interface RAM_if (input clk);
  logic [9:0] din;
  logic [7:0] dout, dout_ref;
  logic rx_valid, tx_valid, tx_valid_ref;
  logic rst_n;
  
   parameter ADDR_SIZE = 8;
   parameter MEM_DEPTH = 256;

  modport SVA_mp (
        input   clk,
                rst_n,
                din,
                rx_valid,
              output  dout,
                     tx_valid
    );

    modport DUT (
      input  clk,
             rst_n,
             din,
             rx_valid,
      output dout,
             tx_valid
  );

  modport REF (
      input  clk,
             rst_n,
             din,
             rx_valid,
      output dout_ref,
             tx_valid_ref
  );
endinterface : RAM_if