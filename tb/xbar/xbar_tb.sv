module xbar_tb;

  // Parameters
  localparam  ELEM_WIDTH = 4;
  localparam  NUM_ELEM = 6;

  // Ports
  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]       inputs      ;
  logic [NUM_ELEM-1:0][$clog2(NUM_ELEM)-1:0] input_select;
  logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0]       outputs     ;

  xbar 
  #(
    .ELEM_WIDTH(ELEM_WIDTH ),
    .NUM_ELEM (
        NUM_ELEM )
  )
  xbar_dut (
    .input_select ( input_select ),
    .inputs (inputs ),
    .outputs  ( outputs)
  );

  initial begin
    inputs       <= '{10, 11, 12, 13, 14, 15};
    input_select <= '{ 0,  0,  2,  2,  1,  1};
    #100;
    $display("IP: %p", inputs);
    $display("SE: %p", input_select);
    $display("OP: %p", outputs);
    $finish;
  end


endmodule
