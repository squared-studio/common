////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module async_fifo_tb;
initial begin
  $dumpfile("raw.vcd");
  $dumpvars;
  $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
end
final begin
  $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
end

localparam int ElemWidth = 8;
localparam int ElemSize  = 2;

int pass;
int fail;
int cnt;

logic                  arst_n_i        ;
logic                  clk_in_i        ;
logic [ElemWidth-1:0] data_in_i        ;
logic                  data_in_valid_i ;
logic                  data_in_ready_o ;
logic                  clk_out_i       ;
logic [ElemWidth-1:0] data_out_o       ;
logic                  data_out_valid_o;
logic                  data_out_ready_i;

async_fifo #(
  .ElemWidth ( ElemWidth ),
  .ElemSize  ( 2          )
) u_async_fifo (
  .clk_in_i          ( clk_in_i          ),
  .arst_n_i         ( arst_n_i         ),
  .data_in_i        ( data_in_i        ),
  .data_in_valid_i  ( data_in_valid_i  ),
  .data_in_ready_o  ( data_in_ready_o  ),
  .clk_out_i          ( clk_out_i          ),
  .data_out_o       ( data_out_o       ),
  .data_out_valid_o ( data_out_valid_o ),
  .data_out_ready_i ( data_out_ready_i )
);

task static start_clock ();
  fork
    forever begin
      clk_in_i = 1; #5;
      clk_in_i = 0; #5;
    end
    forever begin
      clk_out_i = 1; #5;
      clk_out_i = 0; #6;
    end
  join_none
  repeat (2) @ (posedge clk_in_i);
endtask

logic [ElemWidth-1:0] data_queue [$];

task static apply_reset();
  data_queue.delete();
  pass = 0;
  fail = 0;
  cnt  = 0;
  clk_in_i = 1;
  data_in_i = 0;
  data_in_valid_i = 0;
  data_out_ready_i = 0;
  arst_n_i = 0; #5;
  arst_n_i = 1; #5;
endtask

always @(posedge clk_in_i) begin
  if (data_in_valid_i && data_in_ready_o) begin
    cnt++;
    data_queue.push_back(data_in_i);
  end
end

always @(posedge clk_out_i) begin
  if (data_out_valid_o && data_out_ready_i) begin
    cnt--;
    if (data_queue.pop_front() == data_out_o) begin
      pass++;
    end
    else begin
      fail++;
    end
  end
end

initial begin
  apply_reset();
  start_clock();

  repeat(1000) begin
    @ (posedge clk_in_i);
    data_in_i <= $urandom();
    data_in_valid_i  <= !($urandom_range(0,1));
    data_out_ready_i <= !($urandom_range(0,5));
  end

  @ (posedge clk_in_i);
  data_in_valid_i  <= '0;
  data_out_ready_i <= '1;

  while (cnt > 0) @ (posedge clk_in_i);

  repeat(2) @ (posedge clk_in_i);

  $display("%0d/%0d PASSED", pass, pass+fail);

  $finish();
end
endmodule
