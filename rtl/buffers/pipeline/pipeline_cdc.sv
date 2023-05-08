////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : pipeline_cdc
//    DESCRIPTION : pipeline for clock domain crossing
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                            arst_ni
                       ----------↓---------
                      ¦                    ¦
             clk_in_i →                    ← clk_out_i
[ElemWidth] elem_in_i →    pipeline_cdc    → [ElemWidth] elem_out_o
      elem_in_valid_i →                    → elem_out_valid_o
      elem_in_ready_o ←                    ← elem_out_ready_i
                      ¦                    ¦
                       --------------------
*/

module pipeline_cdc #(
    parameter int ElemWidth = 8
) (
    input logic arst_ni,

    input  logic                 clk_in_i,
    input  logic [ElemWidth-1:0] elem_in_i,
    input  logic                 elem_in_valid_i,
    output logic                 elem_in_ready_o,

    input  logic                 clk_out_i,
    output logic [ElemWidth-1:0] elem_out_o,
    output logic                 elem_out_valid_o,
    input  logic                 elem_out_ready_i
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [ElemWidth-1:0] mem;
  logic                 mem_full;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign elem_out_o = mem;
  assign elem_out_valid_o = mem_full;
  assign elem_in_ready_o = ~mem_full;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always @(negedge arst_ni) begin
    if (~arst_ni) begin
      mem      <= '0;
      mem_full <= '0;
    end
  end

  always @(posedge clk_in_i) begin
    if (arst_ni) begin
      if (elem_in_valid_i & elem_in_ready_o) mem_full <= '1;
      mem <= elem_in_i;
    end
  end

  always @(posedge clk_in_i) begin
    if (arst_ni) begin
      if (elem_out_valid_o & elem_out_ready_i) mem_full <= '0;
    end
  end

endmodule
