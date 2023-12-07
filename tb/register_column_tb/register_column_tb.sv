// ### Basic tb for register_page
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

module register_column_tb;
  logic [7:0]                   in;
  logic          [9:0]          addr;
  logic                         clk_i;
  logic                         arst_ni;
  logic                         en_i;
  logic[7:0]                    out;
  
  
  register_column u_1_register_column
  ( .in(in),
    .addr(addr),
    .clk_i(clk_i),
    .arst_ni(arst_ni),
    .en_i(en_i),
    .out(out)
  );
  
  task start_clock ();
    fork
      forever begin
        clk_i = 1; #5;
        clk_i = 0; #5;
      end
    join_none
  endtask
  task apply_reset ();
    clk_i   = 1 ;
    arst_ni = 1 ;
    
    #50         ;
    arst_ni = 0 ;
    in      =0  ;
    addr    =0  ;
    en_i    =0  ;
    
    #50        ;
    arst_ni = 1;
    #50        ;
  endtask
  initial 
  begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  initial
  begin
    apply_reset ();
    start_clock ();
    #150;
    for(int i=0;i<100;i++)
    begin
      in   <= $urandom;
      addr <= $urandom;
      en_i <= 1;
      repeat(2) @(posedge clk_i);
      $display("write_data=%d, en=%d, read_data=%d,address =%0d",in,en_i,out,addr);
    end
    $finish;
  end
endmodule