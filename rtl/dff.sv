// ### Author : Foez Ahmed (foez.official@gmail.com)

module dff #(
    parameter bit RESET_VALUE = '0
) (
    input logic arst_ni,
    input logic clk_i,

    input logic en_i,
    input logic d_i,

    output logic q_o
);

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= RESET_VALUE;
    end else if (en_i) begin
      q_o <= d_i;
    end
  end

endmodule

// TODO
