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
                            arst_n_i
                       ---------↓--------
                      ¦                  ¦
             clk_in_i →                  ← clk_out_i
[ElemWidth] data_in_i →    async_fifo    → [ElemWidth] data_out_o
      data_in_valid_i →                  → data_out_valid_o
      data_in_ready_o ←                  ← data_out_ready_i
                      ¦                  ¦
                       ------------------
*/

module async_fifo #(
    parameter int ElemWidth = 8,
    parameter int ElemSize  = 2,
    parameter int Depth     = 2**ElemSize
) (
    input  logic                  arst_n_i,

    input  logic                  clk_in_i,
    input  logic [ElemWidth-1:0] data_in_i,
    input  logic                  data_in_valid_i,
    output logic                  data_in_ready_o,

    input  logic                  clk_out_i,
    output logic [ElemWidth-1:0] data_out_o,
    output logic                  data_out_valid_o,
    input  logic                  data_out_ready_i
);

    logic [ElemWidth-1:0] mem [Depth];

    logic [ElemSize:0] wr_ptr;
    logic [ElemSize:0] rd_ptr;

    assign data_in_ready_o  = (
        {~wr_ptr[ElemSize], wr_ptr[ElemSize-1:0]} ==
        {rd_ptr[ElemSize], rd_ptr[ElemSize-1:0]}
        ) ? '0 : '1;

    assign data_out_valid_o = (
        {wr_ptr[ElemSize], wr_ptr[ElemSize-1:0]} ==
        {rd_ptr[ElemSize], rd_ptr[ElemSize-1:0]}
        ) ? '0 : '1;

    assign data_out_o = mem [rd_ptr[ElemSize-1:0]];


    always_ff @( posedge clk_in_i or negedge arst_n_i ) begin
        if (~arst_n_i) begin
            wr_ptr <= '0;
        end
        else begin
            if (data_in_valid_i  & data_in_ready_o) begin
                mem [wr_ptr[ElemSize-1:0]] <= data_in_i;
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    always_ff @( posedge clk_out_i or negedge arst_n_i ) begin
        if (~arst_n_i) begin
            rd_ptr <= '0;
        end
        else begin
            if (data_out_valid_o & data_out_ready_i) begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

endmodule
