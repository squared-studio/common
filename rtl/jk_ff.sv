/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

module jk_ff (
    input logic clk_i,
    input logic arst_ni,

    input logic j_i,
    input logic k_i,

    output logic q_o,
    output logic q_no
);

  assign q_no = ~q_o;

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= 0;
    end else begin
      case ({
        j_i, k_i
      })
        2'b01:   q_o <= '0;
        2'b10:   q_o <= '1;
        2'b11:   q_o <= q_no;
        default: q_o <= q_o;
      endcase
    end
  end

endmodule

// TODO
