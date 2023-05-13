////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : handshake_storage
//    DESCRIPTION : a module for keeping track of valid ready handshakes and matching in triple
//                  handshakes
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
             clk_i            arst_ni
            ---↓-----------------↓---
           ¦                         ¦
in_valid_i →    handshake_storage    → out_valid_o
in_ready_o ←                         ← out_ready_i
           ¦                         ¦
            ------------↓------------
                      cnt_o
*/

module handshake_storage #(
    parameter int Depth = 4
) (
    input  logic                       clk_i,
    input  logic                       arst_ni,
    input  logic                       in_valid_i,
    output logic                       in_ready_o,
    output logic                       out_valid_o,
    input  logic                       out_ready_i,
    output logic [$clog2(Depth+1)-1:0] cnt_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic in_hs;
  logic out_hs;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign in_ready_o = (cnt_o != Depth);
  assign out_valid_o = (cnt_o != '0);

  assign in_hs = in_valid_i & in_ready_o;
  assign out_hs = out_valid_o & out_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SEQUENCIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      cnt_o <= '0;
    end else begin
      case ({
        in_hs, out_hs
      })
        2'b01:   cnt_o <= cnt_o - 1;
        2'b10:   cnt_o <= cnt_o + 1;
        default: cnt_o <= cnt_o;
      endcase
    end
  end

endmodule
