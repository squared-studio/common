// General Purpose Latch
// ### Author : Foez Ahmed (foez.official@gmail.com)

module latch #(
    parameter int DATA_WIDTH = 8  // Data Width
) (
    input logic arst_ni,  // Asynchronous reset
    input logic en_i,     // Latch enable

    input logic [DATA_WIDTH-1:0] d_i,  // Latch data in

    output logic [DATA_WIDTH-1:0] q_o  // Latch data out
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(en_i or d_i or arst_ni) begin
    if (~arst_ni) q_o = '0;
    else if (en_i) q_o = d_i;
  end

endmodule
