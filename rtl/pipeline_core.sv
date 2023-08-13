// ### Author : Foez Ahmed (foez.official@gmail.com)

module pipeline_core #(
    parameter int ELEM_WIDTH = 8
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [ELEM_WIDTH-1:0] elem_in_i,
    input  logic                  elem_in_valid_i,
    output logic                  elem_in_ready_o,

    output logic [ELEM_WIDTH-1:0] elem_out_o,
    output logic                  elem_out_valid_o,
    input  logic                  elem_out_ready_i
);

  logic                  is_full;
  logic [ELEM_WIDTH-1:0] mem;

  logic                  input_handshake;
  logic                  output_handshake;

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
