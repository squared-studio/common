////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module ff_back_to_back #(
    parameter int NumStages = 4
) (
    input  logic clk_i,
    input  logic arst_ni,
    input  logic en_i,
    input  logic d_i,
    output logic q_o
);

  logic [NumStages-1:0] mem;

  assign q_o = mem[NumStages-1];

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      mem <= '0;
    end else begin
      if (en_i) begin
        mem <= {mem[NumStages-2:0], d_i};
      end
    end
  end

endmodule
