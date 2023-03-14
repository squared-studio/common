module tb_fifo_async;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
  end
  final begin
    $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
  end

  localparam DATA_WIDTH = 8;
  localparam DATA_SIZE  = 2;

  int pass;
  int fail;
  int cnt;

  logic                  arst_n        ; 
  logic                  clk_i         ; 
  logic [DATA_WIDTH-1:0] data_in       ; 
  logic                  data_in_valid ; 
  logic                  data_in_ready ; 
  logic                  clk_o         ; 
  logic [DATA_WIDTH-1:0] data_out      ; 
  logic                  data_out_valid; 
  logic                  data_out_ready; 

  fifo_async #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .DATA_SIZE  ( 2          )
  ) u_fifo_async (
    .clk_i          ( clk_i          ),
    .arst_n         ( arst_n         ),
    .data_in        ( data_in        ),
    .data_in_valid  ( data_in_valid  ),
    .data_in_ready  ( data_in_ready  ),
    .clk_o          ( clk_o          ),
    .data_out       ( data_out       ),
    .data_out_valid ( data_out_valid ),
    .data_out_ready ( data_out_ready )
  );

  task start_clock ();
    fork
      forever begin
        clk_i = 1; #5;
        clk_i = 0; #5;
      end
      forever begin
        clk_o = 1; #5;
        clk_o = 0; #6;
      end
    join_none
    repeat (2) @ (posedge clk_i);
  endtask

  logic [DATA_WIDTH-1:0] data_queue [$];

  task apply_reset ();
    data_queue.delete();
    pass = 0;
    fail = 0;
    cnt  = 0;
    clk_i = 1;
    data_in = 0;
    data_in_valid = 0;
    data_out_ready = 0;
    arst_n = 0; #5;
    arst_n = 1; #5;
  endtask

  always @(posedge clk_i) begin
    if (data_in_valid && data_in_ready) begin
      cnt++;
      data_queue.push_back(data_in);
    end
  end

  always @(posedge clk_o) begin
    if (data_out_valid && data_out_ready) begin
      cnt--;
      if (data_queue.pop_front() == data_out) begin
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
      @ (posedge clk_i);
      data_in <= $random();
      data_in_valid  <= !($urandom_range(0,1));
      data_out_ready <= !($urandom_range(0,5));
    end

    @ (posedge clk_i);
    data_in_valid  <= '0;
    data_out_ready <= '1;
    
    while (cnt > 0) @ (posedge clk_i);

    repeat(2) @ (posedge clk_i);

    $display("%0d/%0d PASSED", pass, pass+fail);

    $finish();
  end
endmodule