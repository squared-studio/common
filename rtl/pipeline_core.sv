/*
The `pipeline_core` module is a parameterized SystemVerilog module that implements a pipeline core.
The module uses a flip-flop to control the state of the pipeline based on the input and output
handshakes.
Author : Foez Ahmed (foez.official@gmail.com)
*/

module pipeline_core #(
    parameter int ELEM_WIDTH = 8  // width of each pipeline element
) (
    input logic clk_i,   // global clock signal
    input logic arst_ni, // asynchronous active low reset signal

    input  logic [ELEM_WIDTH-1:0] elem_in_i,        // input element
    input  logic                  elem_in_valid_i,  // input element valid signal
    output logic                  elem_in_ready_o,  // input element ready signal

    output logic [ELEM_WIDTH-1:0] elem_out_o,        // output element
    output logic                  elem_out_valid_o,  // output element valid signal
    input  logic                  elem_out_ready_i   // output element ready signal
);

  logic                  is_full;  // indicates whether the pipeline is full
  logic [ELEM_WIDTH-1:0] mem;  // holds the pipeline memory

  logic                  input_handshake;  // indicates a successful input handshake
  logic                  output_handshake;  // indicates a successful output handshake

  assign elem_in_ready_o  = (is_full) ? elem_out_ready_i : '1;
  assign elem_out_o       = mem;
  assign elem_out_valid_o = is_full;
  assign input_handshake  = elem_in_valid_i & elem_in_ready_o;
  assign output_handshake = elem_out_valid_o & elem_out_ready_i;

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

// TODO
