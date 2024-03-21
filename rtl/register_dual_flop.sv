// ### Author : Foez Ahmed (foez.official@gmail.com)

module register_dual_flop #(
    parameter int                  ELEM_WIDTH             = 32,
    parameter bit [ELEM_WIDTH-1:0] RESET_VALUE            = '0,
    parameter bit                  FIRST_FF_EDGE_POSEDGED = 1,
    parameter bit                  LAST_FF_EDGE_POSEDGED  = 0
) (
    input logic clk_i,
    input logic arst_ni,

    input logic en_i,
    input logic [ELEM_WIDTH-1:0] d_i,

    output logic [ELEM_WIDTH-1:0] q_o
);

  logic [ELEM_WIDTH-1:0] q_intermediate;
  logic en_intermediate;

  logic first_clk_in;
  logic last_clk_in;

  assign first_clk_in = FIRST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;
  assign last_clk_in  = LAST_FF_EDGE_POSEDGED ? clk_i : ~clk_i;

  always_ff @(posedge first_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      q_intermediate  <= RESET_VALUE;
      en_intermediate <= '0;
    end else begin
      q_intermediate  <= d_i;
      en_intermediate <= en_i;
    end
  end

  always_ff @(posedge last_clk_in or negedge arst_ni) begin
    if (~arst_ni) begin
      q_o <= RESET_VALUE;
    end else begin
      if (en_intermediate) q_o <= q_intermediate;
    end
  end

endmodule

// TODO
