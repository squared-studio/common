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
                        clk_i      arst_ni
                       ---↓-----------↓---
                      ¦                   ¦
[ElemWidth] elem_in_i →                   → [ElemWidth] elem_out_o
      elem_in_valid_i →    peline_core    → elem_out_valid_o
      elem_in_ready_o ←                   ← elem_out_ready_i
                      ¦                   ¦
                       -------------------
*/

module pipeline_core #(
    parameter int ElemWidth = 8
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

  logic                 is_full;
  logic [ElemWidth-1:0] mem;

  logic                 input_handshake;
  logic                 output_handshake;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign elem_in_ready_o  = (is_full) ? elem_out_ready_i : '1;
  assign elem_out_o       = mem;
  assign elem_out_valid_o = is_full;
  assign input_handshake  = elem_in_valid_i & elem_in_ready_o;
  assign output_handshake = elem_out_valid_o & elem_out_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin : main_block
    if (~arst_ni) begin : do_reset
      is_full <= '0;
    end else begin : not_reset
      if (input_handshake) begin
        mem <= elem_in_i;
      end
      case ({
        input_handshake, output_handshake
      })
        2'b01:   is_full <= '0;
        2'b10:   is_full <= '1;
        2'b11:   is_full <= '1;
        default: is_full <= is_full;
      endcase
    end
  end

endmodule