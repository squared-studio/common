`include "cmp/pipeline.sv"

module tb_pipeline;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
  end
  final begin
    $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
  end

  localparam WIDTH      = 8;
  localparam NUM_STAGES = 8;

  logic             clk_i         ; 
  logic             arst_n        ; 
  logic [WIDTH-1:0] data_in       ; 
  logic             data_in_valid ; 
  logic             data_in_ready ; 
  logic [WIDTH-1:0] data_out      ; 
  logic             data_out_valid; 
  logic             data_out_ready; 

  pipeline #(
    .WIDTH      ( WIDTH      ),
    .NUM_STAGES ( NUM_STAGES )
  ) u_pipeline (
    .clk_i          ( clk_i          ),
    .arst_n         ( arst_n         ),
    .data_in        ( data_in        ),
    .data_in_valid  ( data_in_valid  ),
    .data_in_ready  ( data_in_ready  ),
    .data_out       ( data_out       ),
    .data_out_valid ( data_out_valid ),
    .data_out_ready ( data_out_ready )
  );

  task start_clock ();
    clk_i = 1; #5;
    clk_i = 0; #5;
  endtask

  task apply_reset ();
    clk_i = 1; #5;
    clk_i = 0; #5;
  endtask

  initial begin
    $display("Hi");
    $finish();
  end
endmodule