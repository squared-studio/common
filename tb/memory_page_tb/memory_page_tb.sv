// ### Basic tb for register_page
// ### Author : Razu Ahamed (en.razu.ahamed@gmail.com)

module memory_page_tb;
   
  localparam int ELEM_WIDTH = 8;

  logic [ELEM_WIDTH-1:0] in;
  logic [          12:0] addr;
  logic                  clk_i;
  logic                  arst_ni;
  logic                  en_i;
  logic [ELEM_WIDTH-1:0] out;
  
  logic [1023:0][7:0] mem[8];
  logic [7:0] rd_data;
  logic [          12:0]address_queue[$];
  logic [          12:0]address_queue_pop;
  memory_page #(
      .ELEM_WIDTH(ELEM_WIDTH)
  ) u_memory_page(
    .in(in),
    .addr(addr),
    .clk_i(clk_i),
    .arst_ni(arst_ni),
    .en_i(en_i),
    .out(out)
  );
  
  task memory_write (input logic en,input logic [7:0] wr_data, input logic [12:0]addr);
    if(en==1) mem[addr[2:0]][addr[12:3]] = wr_data;
    else      mem[addr[2:0]][addr[12:3]] = 0;
  endtask
  
  task memory_read (output logic [7:0] rd_data, input logic [12:0]addr);
    rd_data = mem[addr[2:0]][addr[12:3]];
  endtask
  
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
    clk_i   = 0 ;
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
  
  int pass =0;
  int fail =0; 
  
  initial
  begin
    apply_reset ();
    start_clock ();

    // Check not written memory location
    for(int i=0;i<100;i++)
    begin
      in   <= $urandom;
      addr <= $urandom;
      en_i <= $urandom;

      repeat(1) @(posedge clk_i);
      address_queue.push_back(addr);
      memory_write (en_i,in,addr);

      if(out == 0) 
      begin
        $display("Pass, Date = %0d that not witten before ",out);
        pass++;
      end
      else
      begin
        $display("Fail, Date = %0d that not witten before ",out);
        fail++;
      end
    end

    // check_written memory location
    for(int i=0;i<100;i++)
    begin
      address_queue_pop = address_queue.pop_front();
      memory_read (rd_data,address_queue_pop);
      addr <= address_queue_pop;
      repeat(1) @(posedge clk_i);
      if(out==rd_data)
      begin
        $display("Expected= %0d and Actual = %0d",rd_data,out);
        pass++;
      end
      else
      begin
        $display("Fail ->Expected= %0d and Actual = %0d",rd_data,out);
        fail++;
      end
    end

    // Write different data twice time in same address and check it work or not 
    for(int i=0;i<100;i++)
    begin
      in   <= $urandom;
      addr <= $urandom;
      en_i <= $urandom;

      repeat(1) @(posedge clk_i);
      address_queue.push_back(addr);
      in   <= $urandom;
      repeat(1) @(posedge clk_i);
      memory_write (en_i,in,addr);
     end
     for(int i=0;i<100;i++)
     begin
       address_queue_pop = address_queue.pop_front();
       memory_read (rd_data,address_queue_pop);
       addr <= address_queue_pop;
       repeat(1) @(posedge clk_i);
       if(out==rd_data)
       begin
         $display("Different data was written-> Expected= %0d and Actual = %0d",rd_data,out);
         pass++;
       end
       else
       begin
         $display("Different data was written Fail -> Expected= %0d and Actual = %0d",rd_data,out);
         fail++;
       end
     end
    $display("pass= %0d and fail = %0d",pass,fail);
    $finish;
  end

endmodule
