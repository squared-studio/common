////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                       clk_i   arst_ni
                      ---↓--------↓---
                     ¦                ¦
[DataWidth] data_in_i →                → [DataWidth] data_out_o
       data_in_valid_i →    pipeline    → data_out_valid_o
       data_in_ready_o ←                ← data_out_ready_i
                     ¦                ¦
                      ----------------
*/

module pipeline #(
    parameter int DataWidth = 8,
    parameter int NumStages = 1
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [DataWidth-1:0] data_in_i,
    input  logic                 data_in_valid_i,
    output logic                 data_in_ready_o,

    output logic [DataWidth-1:0] data_out_o,
    output logic                 data_out_valid_o,
    input  logic                 data_out_ready_i
);

  if (NumStages == 0) begin : g_NumStages_0
    assign data_out_o       = data_in_i;
    assign data_out_valid_o = data_in_valid_i;
    assign data_in_ready_o  = data_out_ready_i;
  end else if (NumStages == 1) begin : g_NumStages_1
    pipeline_core #(
        .DataWidth(DataWidth)
    ) u_pipeline_core (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .data_in_i       (data_in_i),
        .data_in_valid_i (data_in_valid_i),
        .data_in_ready_o (data_in_ready_o),
        .data_out_o      (data_out_o),
        .data_out_valid_o(data_out_valid_o),
        .data_out_ready_i(data_out_ready_i)
    );
  end else begin : g_NumStages_1p

    logic [DataWidth-1:0] data_ [NumStages-1];
    logic                 valid_[NumStages-1];
    logic                 ready_[NumStages-1];

    pipeline_core #(
        .DataWidth(DataWidth)
    ) u_pipeline_core_first (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .data_in_i       (data_in_i),
        .data_in_valid_i (data_in_valid_i),
        .data_in_ready_o (data_in_ready_o),
        .data_out_o      (data_[0]),
        .data_out_valid_o(valid_[0]),
        .data_out_ready_i(ready_[0])
    );

    for (genvar i = 0; i < (NumStages - 2); i++) begin : g_pipeline_core_1p
      pipeline_core #(
          .DataWidth(DataWidth)
      ) u_pipeline_core_middle (
          .clk_i           (clk_i),
          .arst_ni         (arst_ni),
          .data_in_i       (data_[i]),
          .data_in_valid_i (valid_[i]),
          .data_in_ready_o (ready_[i]),
          .data_out_o      (data_[i+1]),
          .data_out_valid_o(valid_[i+1]),
          .data_out_ready_i(ready_[i+1])
      );
    end

    pipeline_core #(
        .DataWidth(DataWidth)
    ) u_pipeline_core_last (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .data_in_i       (data_[NumStages-2]),
        .data_in_valid_i (valid_[NumStages-2]),
        .data_in_ready_o (ready_[NumStages-2]),
        .data_out_o      (data_out_o),
        .data_out_valid_o(data_out_valid_o),
        .data_out_ready_i(data_out_ready_i)
    );

  end

endmodule
