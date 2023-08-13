// ### Author : Foez Ahmed (foez.official@gmail.com)

module register #(
    parameter int                  ELEM_WIDTH  = 32,
    parameter bit [ELEM_WIDTH-1:0] RESET_VALUE = '0
) (
    input  logic                  clk_i,
    input  logic                  arst_ni,
    input  logic                  en_i,
    input  logic [ELEM_WIDTH-1:0] d_i,
    output logic [ELEM_WIDTH-1:0] q_o
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
