////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ### Author : Foez Ahmed (foez.official@gmail.com)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module pipeline #(
    parameter int ElemWidth = 8,
    parameter int NumStages = 1
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [ElemWidth-1:0] elem_in_i,
    input  logic                 elem_in_valid_i,
    output logic                 elem_in_ready_o,

    output logic [ElemWidth-1:0] elem_out_o,
    output logic                 elem_out_valid_o,
    input  logic                 elem_out_ready_i
);

  if (NumStages == 0) begin : g_NumStages_0
    assign elem_out_o       = elem_in_i;
    assign elem_out_valid_o = elem_in_valid_i;
    assign elem_in_ready_o  = elem_out_ready_i;
  end else if (NumStages == 1) begin : g_NumStages_1
    pipeline_core #(
        .ElemWidth(ElemWidth)
    ) u_pipeline_core (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .elem_in_i       (elem_in_i),
        .elem_in_valid_i (elem_in_valid_i),
        .elem_in_ready_o (elem_in_ready_o),
        .elem_out_o      (elem_out_o),
        .elem_out_valid_o(elem_out_valid_o),
        .elem_out_ready_i(elem_out_ready_i)
    );
  end else begin : g_NumStages_1p

    logic [ElemWidth-1:0] elem_ [NumStages-1];
    logic                 valid_[NumStages-1];
    logic                 ready_[NumStages-1];

    pipeline_core #(
        .ElemWidth(ElemWidth)
    ) u_pipeline_core_first (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .elem_in_i       (elem_in_i),
        .elem_in_valid_i (elem_in_valid_i),
        .elem_in_ready_o (elem_in_ready_o),
        .elem_out_o      (elem_[0]),
        .elem_out_valid_o(valid_[0]),
        .elem_out_ready_i(ready_[0])
    );

    for (genvar i = 0; i < (NumStages - 2); i++) begin : g_pipeline_core_1p
      pipeline_core #(
          .ElemWidth(ElemWidth)
      ) u_pipeline_core_middle (
          .clk_i           (clk_i),
          .arst_ni         (arst_ni),
          .elem_in_i       (elem_[i]),
          .elem_in_valid_i (valid_[i]),
          .elem_in_ready_o (ready_[i]),
          .elem_out_o      (elem_[i+1]),
          .elem_out_valid_o(valid_[i+1]),
          .elem_out_ready_i(ready_[i+1])
      );
    end

    pipeline_core #(
        .ElemWidth(ElemWidth)
    ) u_pipeline_core_last (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .elem_in_i       (elem_[NumStages-2]),
        .elem_in_valid_i (valid_[NumStages-2]),
        .elem_in_ready_o (ready_[NumStages-2]),
        .elem_out_o      (elem_out_o),
        .elem_out_valid_o(elem_out_valid_o),
        .elem_out_ready_i(elem_out_ready_i)
    );

  end

endmodule
