module xbar #(
  parameter LINE_WIDTH = 8,
  parameter NUM_LINES  = 6
) (
    input  logic [NUM_LINES-1:0][$clog2(NUM_LINES)-1:0] input_select,
    input  logic [NUM_LINES-1:0][LINE_WIDTH-1:0]        inputs,
    output logic [NUM_LINES-1:0][LINE_WIDTH-1:0]        outputs
);

  always_comb begin : main
    for (int i = 0; i < NUM_LINES; i++) begin
      outputs [i] = inputs[input_select];
    end
  end
    
endmodule //xbar