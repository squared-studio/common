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
                             arst_ni
                       ---------↓--------
                      ¦                  ¦
             clk_in_i →                  ← clk_out_i
[ElemWidth] elem_in_i →    async_fifo    → [ElemWidth] elem_out_o
      elem_in_valid_i →                  → elem_out_valid_o
      elem_in_ready_o ←                  ← elem_out_ready_i
                      ¦                  ¦
                       ------------------
*/

module async_fifo #(
    parameter int ElemWidth = 8,
    parameter int ElemSize  = 2,
    parameter int Depth     = 2**ElemSize
) (
    input  logic                  arst_ni,

    input  logic                  clk_in_i,
    input  logic [ElemWidth-1:0]  elem_in_i,
    input  logic                  elem_in_valid_i,
    output logic                  elem_in_ready_o,

    input  logic                  clk_out_i,
    output logic [ElemWidth-1:0]  elem_out_o,
    output logic                  elem_out_valid_o,
    input  logic                  elem_out_ready_i
);

    logic [ElemWidth-1:0] mem [Depth];

    logic [ElemSize:0] wr_ptr;
    logic [ElemSize:0] rd_ptr;

    assign elem_in_ready_o  = (
        {~wr_ptr[ElemSize], wr_ptr[ElemSize-1:0]} ==
        {rd_ptr[ElemSize], rd_ptr[ElemSize-1:0]}
        ) ? '0 : '1;

    assign elem_out_valid_o = (
        {wr_ptr[ElemSize], wr_ptr[ElemSize-1:0]} ==
        {rd_ptr[ElemSize], rd_ptr[ElemSize-1:0]}
        ) ? '0 : '1;

    assign elem_out_o = mem [rd_ptr[ElemSize-1:0]];


    always_ff @( posedge clk_in_i or negedge arst_ni ) begin
        if (~arst_ni) begin
            wr_ptr <= '0;
        end
        else begin
            if (elem_in_valid_i  & elem_in_ready_o) begin
                mem [wr_ptr[ElemSize-1:0]] <= elem_in_i;
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    always_ff @( posedge clk_out_i or negedge arst_ni ) begin
        if (~arst_ni) begin
            rd_ptr <= '0;
        end
        else begin
            if (elem_out_valid_o & elem_out_ready_i) begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

endmodule
