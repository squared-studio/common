/* 
                    clk_i                     arst_n
                   ---↓-------------------------↓---
                  ¦                                 ¦
          data_in →                                 → data_out
    data_in_valid →          pipeline_core          → data_out_valid
    data_in_ready ←                                 ← data_out_ready
                  ¦                                 ¦
                   ---------------------------------
*/

module pipeline_core #(
  parameter WIDTH = 8
) (
  input  logic             clk_i,
  input  logic             arst_n,

  input  logic [WIDTH-1:0] data_in,
  input  logic             data_in_valid,
  output logic             data_in_ready,

  output logic [WIDTH-1:0] data_out,
  output logic             data_out_valid,
  input  logic             data_out_ready
);

  logic             is_full;
  logic [WIDTH-1:0] mem;

  logic input_handshake;
  logic output_handshake;

  assign data_in_ready    = (is_full) ? data_out_ready : '1;
  assign data_out         = mem;
  assign data_out_valid   = is_full;
  assign input_handshake  = data_in_valid & data_in_ready;
  assign output_handshake = data_out_valid & data_out_ready;

  always_ff @( posedge clk_i ) begin : main_block
    if (arst_n) begin

      if (input_handshake) begin
        mem <= data_in;
      end

      case ({input_handshake, output_handshake})
        2'b01   : is_full <= '0;
        2'b10   : is_full <= '1;
        2'b11   : is_full <= '1;
        default : is_full <= is_full;
      endcase

    end

    else begin
      is_full <= '0;
    end
  end

endmodule