// ### Author : Foez Ahmed (foez.official@gmail.com)

module pipeline #(
    parameter int ELEM_WIDTH = 8,
    parameter int NUM_STAGES = 1
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [ELEM_WIDTH-1:0] elem_in_i,
    input  logic                  elem_in_valid_i,
    output logic                  elem_in_ready_o,

    output logic [ELEM_WIDTH-1:0] elem_out_o,
    output logic                  elem_out_valid_o,
    input  logic                  elem_out_ready_i
);

  if (NUM_STAGES == 0) begin : g_NumStages_0
    assign elem_out_o       = elem_in_i;
    assign elem_out_valid_o = elem_in_valid_i;
    assign elem_in_ready_o  = elem_out_ready_i;
  end else if (NUM_STAGES == 1) begin : g_NumStages_1
    pipeline_core #(
        .ELEM_WIDTH(ELEM_WIDTH)
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

    logic [ELEM_WIDTH-1:0] elem_ [NUM_STAGES-1];
    logic                  valid_[NUM_STAGES-1];
    logic                  ready_[NUM_STAGES-1];

    pipeline_core #(
        .ELEM_WIDTH(ELEM_WIDTH)
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

    for (genvar i = 0; i < (NUM_STAGES - 2); i++) begin : g_pipeline_core_1p
      pipeline_core #(
          .ELEM_WIDTH(ELEM_WIDTH)
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
        .ELEM_WIDTH(ELEM_WIDTH)
    ) u_pipeline_core_last (
        .clk_i           (clk_i),
        .arst_ni         (arst_ni),
        .elem_in_i       (elem_[NUM_STAGES-2]),
        .elem_in_valid_i (valid_[NUM_STAGES-2]),
        .elem_in_ready_o (ready_[NUM_STAGES-2]),
        .elem_out_o      (elem_out_o),
        .elem_out_valid_o(elem_out_valid_o),
        .elem_out_ready_i(elem_out_ready_i)
    );

  end

endmodule

// TODO
