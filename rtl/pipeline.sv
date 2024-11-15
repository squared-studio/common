/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

module pipeline #(
    parameter int ELEM_WIDTH = 8  // width of each pipeline element
) (
    input logic arst_ni,  // asynchronous active low reset signal
    input logic clk_i,    // global clock signal
    input logic rst_i,    // synchronous reset signal

    input  logic [ELEM_WIDTH-1:0] elem_in_i,        // input element
    input  logic                  elem_in_valid_i,  // input element valid signal
    output logic                  elem_in_ready_o,  // input element ready signal

    output logic [ELEM_WIDTH-1:0] elem_out_o,        // output element
    output logic                  elem_out_valid_o,  // output element valid signal
    input  logic                  elem_out_ready_i   // output element ready signal
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic                  is_full;  // indicates whether the pipeline is full
  logic                  input_handshake;  // indicates a successful input handshake
  logic                  output_handshake;  // indicates a successful output handshake

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign elem_in_ready_o  = arst_ni & ~rst_i & ((is_full) ? elem_out_ready_i : '1);
  assign elem_out_valid_o = arst_ni & ~rst_i & is_full;

  assign input_handshake  = elem_in_valid_i & elem_in_ready_o;
  assign output_handshake = elem_out_valid_o & elem_out_ready_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i) begin
    if (input_handshake) begin
      elem_out_o <= elem_in_i;
    end
  end

  always_ff @(posedge clk_i or negedge arst_ni) begin : main_block
    if (~arst_ni) begin
      is_full <= '0;
    end else begin
      if (rst_i) begin
        casex ({
          rst_i, input_handshake, output_handshake
        })
          3'b1xx, 3'b001: is_full <= '0;
          3'b010, 3'b011: is_full <= '1;
          default:        is_full <= is_full;
        endcase
      end
    end
  end

endmodule
