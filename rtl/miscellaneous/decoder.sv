// ### Author : Foez Ahmed (foez.official@gmail.com)

module decoder #(
    parameter int CODE_WIDTH = 4
) (
    input logic  [   CODE_WIDTH-1:0] code_i,
    output logic [2**CODE_WIDTH-1:0] out_o
);

  for (genvar i = 0; i < (2 ** CODE_WIDTH); i++) begin : g_outputs
    assign out_o[i] = (code_i == i);
  end

endmodule
