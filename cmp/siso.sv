/* 
                         clk_i             arst_n               en
                        ---↓------------------↓------------------↓---
                       ¦                                             ¦
[SERIAL_WIDTH] data_in →                    siso                     → [SERIAL_WIDTH] data_out
                       ¦                                             ¦
                       ----------------------------------------------
*/

module siso #(
  parameter SERIAL_WIDTH = 8,
  parameter DEPTH        = 5
) (
  input  logic                    clk_i,
  input  logic                    arst_n,
  input  logic                    en,
  input  logic [SERIAL_WIDTH-1:0] data_in,
  output logic [SERIAL_WIDTH-1:0] data_out
);
  
  logic [SERIAL_WIDTH-1:0] mem [DEPTH];

  assign data_out = mem [DEPTH-1];

  always_ff @( posedge clk_i or negedge arst_n ) begin : main
    if (~arst_n) begin : do_reset
      for (int i = 0; i < DEPTH; i++) begin
        mem [i] <= '0;
      end
    end
    else begin : not_reset
      if (en) begin
        mem [0] <= data_in;
        for (int i = 1; i < DEPTH; i++) begin
          mem [i] <= mem [i-1];
        end
      end
    end
  end

endmodule