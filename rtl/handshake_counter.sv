/*
The `handshake_counter` module is a parameterized SystemVerilog module that implements a handshake
counter. The module uses a flip-flop to count the number of handshakes.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module handshake_counter #(
    parameter int DEPTH = 4  // depth of the counter
) (
    input logic clk_i,   // global clock signal
    input logic arst_ni, // asynchronous active low reset signal

    input  logic in_valid_i,  // input valid signal
    output logic in_ready_o,  // input ready signal

    output logic out_valid_o,  // output valid signal
    input  logic out_ready_i,  // output ready signal

    output logic [$clog2(DEPTH+1)-1:0] cnt_o  // counter output
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic in_hs;  // input handshake signal
  logic out_hs;  // output handshake signal

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // `in_ready_o` is assigned the inverse of the condition `cnt_o == DEPTH`
  assign in_ready_o = (cnt_o != DEPTH);
  // `out_valid_o` is assigned the inverse of the condition `cnt_o == 0`
  assign out_valid_o = (cnt_o != '0);

  // `in_hs` is assigned the bitwise AND of `in_valid_i` and `in_ready_o`
  assign in_hs = in_valid_i & in_ready_o;
  // `out_hs` is assigned the bitwise AND of `out_valid_o` and `out_ready_i`
  assign out_hs = out_valid_o & out_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // This block updates `cnt_o` at the positive edge of `clk_i` or the negative edge of `arst_ni`.
  // If `arst_ni` is `0`, `cnt_o` is reset to `0`. Otherwise, `cnt_o` is updated based on the values
  // of `in_hs` and `out_hs`.
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
