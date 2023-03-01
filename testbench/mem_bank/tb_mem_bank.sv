module tb_mem_bank;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
  end
  final begin
    $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
  end


  int pass;
  int fail;
  int cnt;

  logic                  clk_i         ; 

  mem_bank #(
    .ADDR_WIDTH ( 14 ),
    .DATA_SIZE  ( 2 )
  ) u_mem_bank (
    .clk_i          ( clk_i          )
  );

  task start_clock ();
    fork
      forever begin
        clk_i = 1; #5;
        clk_i = 0; #5;
      end
    join_none
    repeat (2) @ (posedge clk_i);
  endtask

  initial begin
    start_clock();

    repeat(2) @ (posedge clk_i);

    $finish();
  end
  
endmodule