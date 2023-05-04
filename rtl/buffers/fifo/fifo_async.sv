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
                                          arst_n
                      ----------------------↓-----------------------
                     ¦                                              ¦
               clk_i →                                              ← clk_o
[DATA_WIDTH] data_in →                     fifo                     → [DATA_WIDTH] data_out
       data_in_valid →                                              → data_out_valid
       data_in_ready ←                                              ← data_out_ready
                     ¦                                              ¦
                      ----------------------------------------------
*/

module fifo_async #(
    parameter  DATA_WIDTH = 8,
    parameter  DATA_SIZE  = 2,
    localparam DEPTH      = 2**DATA_SIZE
) (
    input  logic                  arst_n,

    input  logic                  clk_i,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic                  data_in_valid,
    output logic                  data_in_ready,

    input  logic                  clk_o,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  data_out_valid,
    input  logic                  data_out_ready
);

    logic [DATA_WIDTH-1:0] mem [DEPTH];

    logic [DATA_SIZE:0] wr_ptr;
    logic [DATA_SIZE:0] rd_ptr;

    assign data_in_ready  = ({~wr_ptr[DATA_SIZE], wr_ptr[DATA_SIZE-1:0]} == {rd_ptr[DATA_SIZE], rd_ptr[DATA_SIZE-1:0]}) ? '0 : '1;
    assign data_out_valid = ({wr_ptr[DATA_SIZE], wr_ptr[DATA_SIZE-1:0]} == {rd_ptr[DATA_SIZE], rd_ptr[DATA_SIZE-1:0]}) ? '0 : '1;

    assign data_out = mem [rd_ptr[DATA_SIZE-1:0]];


    always_ff @( posedge clk_i or negedge arst_n ) begin
        if (~arst_n) begin
            wr_ptr <= '0;
        end
        else begin
            if (data_in_valid  & data_in_ready) begin 
                mem [wr_ptr[DATA_SIZE-1:0]] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    always_ff @( posedge clk_o or negedge arst_n ) begin
        if (~arst_n) begin
            rd_ptr <= '0;
        end
        else begin
            if (data_out_valid & data_out_ready) begin 
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

endmodule