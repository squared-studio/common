/*
The `handshake_combiner` module is a parameterized SystemVerilog module that combines handshake
signals from multiple source(s) & destination(s). The module uses two `always_comb` blocks to
generate the `tx_ready` and `rx_valid` signals based on the `tx_valid` and `rx_ready` inputs.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module handshake_combiner #(
    parameter int NUM_TX = 2,  // number of transmitter handshakes
    parameter int NUM_RX = 2   // number of receiver handshakes
) (
    // transmitter valid signals
    input  logic [NUM_TX-1:0] tx_valid,
    // transmitter ready signals
    output logic [NUM_TX-1:0] tx_ready,

    // receiver valid signals
    output logic [NUM_RX-1:0] rx_valid,
    // receiver ready signals
    input  logic [NUM_RX-1:0] rx_ready
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // This block generates the `tx_ready` signals. For each transmitter, the corresponding `tx_ready`
  // signal is initially set to `1`, and then bitwise ANDed with all `rx_ready` signals and all
  // other `tx_valid` signals.
  always_comb begin
    foreach (tx_ready[i]) begin
      tx_ready[i] = 1;
      foreach (rx_ready[j]) tx_ready[i] &= rx_ready[j];
      foreach (tx_valid[j]) if (j != i) tx_ready[i] &= tx_valid[j];
    end
  end

  // This block generates the `rx_valid` signals. For each receiver, the corresponding `rx_valid`
  // signal is initially set to `1`, and then bitwise ANDed with all `tx_valid` signals and all
  // other `rx_ready` signals.
  always_comb begin
    foreach (rx_valid[i]) begin
      rx_valid[i] = 1;
      foreach (tx_valid[j]) rx_valid[i] &= tx_valid[j];
      foreach (rx_ready[j]) if (j != i) rx_valid[i] &= rx_ready[j];
    end
  end

endmodule
