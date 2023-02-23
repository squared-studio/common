/* 
                  clk_i                      arst_n
                 ---↓--------------------------↓---
                ¦                                  ¦
[WIDTH] data_in →                                  → [WIDTH] data_out
  data_in_valid →             pipeline             → data_out_valid
  data_in_ready ←                                  ← data_out_ready
                ¦                                  ¦
                 ----------------------------------
*/

module pipeline #(
  parameter WIDTH      = 8,
  parameter NUM_STAGES = 3
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

endmodule