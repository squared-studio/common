module tb_siso;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars;
    $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
  end
  final begin
    $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
  end

  localparam SERIAL_WIDTH = 8;
  localparam DEPTH        = 8;

  int pass;
  int fail;
  int cnt;

  logic                    clk_i         ; 
  logic                    arst_n        ; 
  logic                    en            ; 
  logic [SERIAL_WIDTH-1:0] data_in       ; 
  logic [SERIAL_WIDTH-1:0] data_out      ; 

  siso #(
    .SERIAL_WIDTH ( SERIAL_WIDTH ),
    .DEPTH        ( DEPTH      )
  ) u_siso (
    .clk_i          ( clk_i          ),
    .arst_n         ( arst_n         ),
    .en             ( en             ),
    .data_in        ( data_in        ),
    .data_out       ( data_out       )
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

  logic [SERIAL_WIDTH-1:0] data_queue [$];

  task apply_reset ();
    data_queue.delete();
    repeat (DEPTH) data_queue.push_back('0);
    pass = 0;
    fail = 0;
    cnt  = 0;
    clk_i = 1;
    data_in = 0;
    en = 0;
    arst_n = 0; #5;
    arst_n = 1; #5;
  endtask

  always @(posedge clk_i) begin
    if (en) begin
      cnt++;
      data_queue.push_back(data_in);
    end
    if (en) begin
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
      en <= !($urandom_range(0,5));
    end

    @ (posedge clk_i);
    en <= '1;
    
    while (cnt > 0) @ (posedge clk_i);

    repeat(2) @ (posedge clk_i);

    $display("%0d/%0d PASSED", pass, pass+fail);

    $finish();
  end
endmodule