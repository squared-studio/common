/*
The `handshake_combiner` module is a parameterized SystemVerilog module that combines handshake
signals from multiple source(s) & destination(s). The module uses two `always_comb` blocks to
generate the `tx_ready_o` and `rx_valid_o` signals based on the `tx_valid_i` and `rx_ready_i`
inputs.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module handshake_combiner #(
    parameter int NUM_TX = 2,  // number of transmitter handshakes
    parameter int NUM_RX = 2   // number of receiver handshakes
) (
    // transmitter valid signals
    input  logic [NUM_TX-1:0] tx_valid_i,
    // transmitter ready signals
    output logic [NUM_TX-1:0] tx_ready_o,

    // receiver valid signals
    output logic [NUM_RX-1:0] rx_valid_o,
    // receiver ready signals
    input  logic [NUM_RX-1:0] rx_ready_i
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  if (NUM_TX == 1 && NUM_RX == 1) begin : g_wire
    assign tx_ready_o = rx_ready_i;
    assign rx_valid_o = tx_valid_i;
  end else begin : g_gate
    logic allow;
    always_comb begin
      allow = '1;
      foreach (tx_valid_i[i]) allow = tx_valid_i[i] & allow;
      foreach (rx_ready_i[i]) allow = rx_ready_i[i] & allow;
    end
    always_comb begin
      foreach (tx_ready_o[i]) tx_ready_o[i] = allow;
      foreach (rx_valid_o[i]) rx_valid_o[i] = allow;
    end
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (NUM_TX < 1) begin
      $fatal(1, "\033[1;33m%m NUM_TX CAN NOT BE LESS THAN 1\033[0m");
    end
    if (NUM_RX < 1) begin
      $fatal(1, "\033[1;33m%m NUM_RX CAN NOT BE LESS THAN 1\033[0m");
    end
  end
`endif  // SIMULATION

endmodule
