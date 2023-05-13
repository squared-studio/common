////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : fifo
//    DESCRIPTION : synchronous fifo buffer with valid ready handshake
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                        clk_i       arst_ni
                       ---↓------------↓---
                      ¦                    ¦
[ElemWidth] elem_in_i →                    → [ElemWidth] elem_out_o
      elem_in_valid_i →        fifo        → elem_out_valid_o
      elem_in_ready_o ←                    ← elem_out_ready_i
                      ¦                    ¦
                       --------------------
*/

module fifo #(
    parameter int ElemWidth = 8,
    parameter int Depth = 5
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

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [ElemWidth-1:0] mem[Depth];

  logic [$clog2(Depth):0] dt_cnt;
  logic [$clog2(Depth):0] wr_ptr;
  logic [$clog2(Depth):0] rd_ptr;
  logic [$clog2(Depth):0] wr_ptr_next;
  logic [$clog2(Depth):0] rd_ptr_next;

  logic elem_in_hs;
  logic elem_out_hs;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign elem_in_ready_o = (dt_cnt == Depth) ? elem_out_ready_i : 1;
  assign elem_out_valid_o = (dt_cnt == 0) ? elem_in_valid_i : '1;

  assign elem_in_hs = elem_in_valid_i & elem_in_ready_o;
  assign elem_out_hs = elem_out_valid_o & elem_out_ready_i;

  assign wr_ptr_next = ((wr_ptr + 1) == Depth) ? '0 : wr_ptr + 1 ;
  assign rd_ptr_next = ((rd_ptr + 1) == Depth) ? '0 : rd_ptr + 1 ;

  assign elem_out_o = dt_cnt ? mem[rd_ptr] : elem_in_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin : main
    if (~arst_ni) begin : not_reset
      dt_cnt <= '0;
      wr_ptr <= '0;
      rd_ptr <= '0;
    end else begin : do_reset
      case ({
        elem_out_hs, elem_in_hs
      })
        2'b11: begin
          dt_cnt <= dt_cnt;
          rd_ptr <= rd_ptr_next;
          wr_ptr <= wr_ptr_next;
        end
        2'b10: begin
          dt_cnt <= dt_cnt - 1;
          rd_ptr <= rd_ptr_next;
          wr_ptr <= wr_ptr;
        end
        2'b01: begin
          dt_cnt <= dt_cnt + 1;
          rd_ptr <= rd_ptr;
          wr_ptr <= wr_ptr_next;
        end
        default: begin
          dt_cnt <= dt_cnt;
          rd_ptr <= rd_ptr;
          wr_ptr <= wr_ptr;
        end
      endcase
      if (elem_in_hs) mem[wr_ptr] <= elem_in_i;
    end
  end

endmodule
