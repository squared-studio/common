////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : reg_file_2r_1w
//    DESCRIPTION : simple reg file with single write and multi read
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                                     clk_i          cs_i
                                    ---↓--------------↓---
                                   ¦                      ¦
[IndexWidth] rd_addr_i[NumReaders] →                      → [ ElemWidth] rd_data_o[NumReaders]
                                   ¦                      ¦
            [IndexWidth] wr_addr_i →    reg_file_nr_1w    ¦
            [ ElemWidth] wr_data_o ←                      ¦
            [ ElemWidth] wr_data_i →                      ¦
                              we_i →                      ¦
                                   ¦                      ¦
                                    ----------------------
*/

module reg_file_nr_1w #(
    parameter int ElemWidth  = 64,
    parameter int IndexWidth = 12,
    parameter int NumReaders = 2
) (
    input logic clk_i,
    input logic cs_i,

    input  logic [IndexWidth-1:0] rd_addr_i[NumReaders],
    output logic [ ElemWidth-1:0] rd_data_o[NumReaders],

    input  logic [IndexWidth-1:0] wr_addr_i,
    output logic [ ElemWidth-1:0] wr_data_o,
    input  logic [ ElemWidth-1:0] wr_data_i,
    input  logic                  we_i
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LOCALPARAMS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int Depth = (2 ** IndexWidth);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [Depth-1:0][ElemWidth-1:0] mem;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign wr_data_o = mem[wr_addr_i];

  for (genvar i = 0; i < NumReaders; i++) begin : g_reads
    assign rd_data_o[i] = mem[rd_addr_i[i]];
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i) begin
    if (cs_i & we_i) begin
      mem[wr_addr_i] <= wr_data_i;
    end
  end

endmodule
