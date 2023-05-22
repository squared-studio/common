////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author      : Foez Ahmed
//
//    Email       : foez.official@gmail.com
//
//    module      : ...
//
//    Description : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module shift_reg #(
    parameter int ElemWidth = 4,
    parameter int Depth     = 8
) (
    input logic clk_i,
    input logic arst_ni,

    input logic load_i,
    input logic en_i,
    input logic l_shift_i,

    input  logic [ElemWidth-1:0] s_i,
    output logic [ElemWidth-1:0] s_o,

    input  logic [Depth-1:0][ElemWidth-1:0] p_i,
    output logic [Depth-1:0][ElemWidth-1:0] p_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign s_o = l_shift_i ? p_o[Depth-1] : p_o[0];

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      p_o <= '0;
    end else if (en_i) begin
      if (load_i) begin
        p_o <= p_i;
      end else begin
        if (l_shift_i) begin
          p_o[0] <= s_i;
          for (int i = 1; i < Depth; i++) begin
            p_o[i] <= p_o[i-1];
          end
        end else begin
          p_o[Depth-1] <= s_i;
          for (int i = 1; i < Depth; i++) begin
            p_o[i-1] <= p_o[i];
          end
        end
      end
    end
  end

endmodule
