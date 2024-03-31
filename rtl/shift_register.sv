/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

module shift_register #(
    parameter int ELEM_WIDTH = 4,
    parameter int DEPTH      = 8
) (
    input logic clk_i,
    input logic arst_ni,

    input logic load_i,
    input logic en_i,
    input logic l_shift_i,

    input  logic [ELEM_WIDTH-1:0] s_i,
    output logic [ELEM_WIDTH-1:0] s_o,

    input  logic [DEPTH-1:0][ELEM_WIDTH-1:0] p_i,
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

// TODO
