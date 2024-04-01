/*
The `shift_register` module is a shift register with configurable element width and depth. It can
load data, enable shifting, and shift left.
Author: Foez Ahmed (foez.official@gmail.com)
*/

module shift_register #(
    parameter int ELEM_WIDTH = 4,  // width of each element
    parameter int DEPTH      = 8   // depth of the shift register
) (
    // clock input
    input logic clk_i,
    // asynchronous active low reset input
    input logic arst_ni,

    // load input
    input logic load_i,
    // enable input
    input logic en_i,
    // left shift input
    input logic l_shift_i,

    // data input
    input  logic [ELEM_WIDTH-1:0] s_i,
    // data output
    output logic [ELEM_WIDTH-1:0] s_o,

    // An array of data inputs
    input  logic [DEPTH-1:0][ELEM_WIDTH-1:0] p_i,
    // An array of data outputs
    output logic [DEPTH-1:0][ELEM_WIDTH-1:0] p_o
);

  assign s_o = l_shift_i ? p_o[DEPTH-1] : p_o[0];

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      p_o <= '0;
    end else if (en_i) begin
      if (load_i) begin
        p_o <= p_i;
      end else begin
        if (l_shift_i) begin
          p_o[0] <= s_i;
          for (int i = 1; i < DEPTH; i++) begin
            p_o[i] <= p_o[i-1];
          end
        end else begin
          p_o[DEPTH-1] <= s_i;
          for (int i = 1; i < DEPTH; i++) begin
            p_o[i-1] <= p_o[i];
          end
        end
      end
    end
  end

endmodule
