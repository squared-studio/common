// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

module handshake_combiner #(
    parameter int NUM_TX = 2,
    parameter int NUM_RX = 2
) (
    input  logic [NUM_TX-1:0] tx_valid,
    output logic [NUM_TX-1:0] tx_ready,

    output logic [NUM_RX-1:0] rx_valid,
    input  logic [NUM_RX-1:0] rx_ready
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin
    foreach (tx_ready[i]) begin
      tx_ready[i] = 1;
      foreach (rx_ready[j]) tx_ready[i] &= rx_ready[j];
      foreach (tx_valid[j]) if (j != i) tx_ready[i] &= tx_valid[j];
    end
  end

  always_comb begin
    foreach (rx_valid[i]) begin
      rx_valid[i] = 1;
      foreach (tx_valid[j]) rx_valid[i] &= tx_valid[j];
      foreach (rx_ready[j]) if (j != i) rx_valid[i] &= rx_ready[j];
    end
  end

  //}}}

endmodule
