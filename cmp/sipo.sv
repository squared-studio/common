/* 
                         clk_i                                 arst_n
                        ---↓--------------------------------------↓---
                       ¦                                              ¦
[SERIAL_WIDTH] data_in →                                              → [PARALLEL_WIDTH] data_out
         data_in_valid →                     sipo                     → data_out_valid
         data_in_ready ←                                              ← data_out_ready
                       ¦                                              ¦
                        ----------------------------------------------
*/

module sipo #(
  parameter  SERIAL_WIDTH   = 8,
  parameter  DEPTH          = 5,
  parameter  LEFT_SHIFT     = 1,
  localparam PARALLEL_WIDTH = (SERIAL_WIDTH * DEPTH)
) (
  input  logic                      clk_i,
  input  logic                      arst_n,

  input  logic [SERIAL_WIDTH-1:0]   data_in,
  input  logic                      data_in_valid,
  output logic                      data_in_ready,

  output logic [PARALLEL_WIDTH-1:0] data_out,
  output logic                      data_out_valid,
  input  logic                      data_out_ready
);
  
  logic [SERIAL_WIDTH-1:0] mem [DEPTH];

  assign data_out_valid = data_in_valid;
  assign data_in_ready = data_out_ready;
  assign data_out = mem [DEPTH-1];


  always_ff @( posedge clk_i or negedge arst_n ) begin : main
    if (~arst_n) begin : do_reset
      for (int i = 0; i < DEPTH; i++) begin
        mem [i] <= '0;
      end
    end
    else begin : not_reset
      if (data_in_valid & data_out_ready) begin
        mem [0] <= data_in;
        for (int i = 1; i < DEPTH; i++) begin
          mem [i] <= mem [i-1];
        end
      end
    end
  end

endmodule