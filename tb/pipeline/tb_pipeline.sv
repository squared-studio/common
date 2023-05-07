////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module tb_pipeline;

  `include "tb_essentials.sv"

  localparam DATA_WIDTH = 8;
  localparam NUM_STAGES = 8;

  int                    pass;
  int                    fail;
  int                    cnt;

  logic                  clk_i;
  logic                  arst_n;
  logic [DATA_WIDTH-1:0] data_in;
  logic                  data_in_valid;
  logic                  data_in_ready;
  logic [DATA_WIDTH-1:0] data_out;
  logic                  data_out_valid;
  logic                  data_out_ready;

  pipeline #(
      .DATA_WIDTH(DATA_WIDTH),
      .NUM_STAGES(NUM_STAGES)
  ) u_pipeline (
      .clk_i         (clk_i),
      .arst_n        (arst_n),
      .data_in       (data_in),
      .data_in_valid (data_in_valid),
      .data_in_ready (data_in_ready),
      .data_out      (data_out),
      .data_out_valid(data_out_valid),
      .data_out_ready(data_out_ready)
  );

  task start_clock();
    fork
      forever begin
        clk_i = 1;
        #5;
        clk_i = 0;
        #5;
      end
    join_none
    repeat (2) @(posedge clk_i);
  endtask

  logic [DATA_WIDTH-1:0] data_queue[$];

  task apply_reset();
    data_queue.delete();
    pass = 0;
    fail = 0;
    cnt = 0;
    clk_i = 1;
    data_in = 0;
    data_in_valid = 0;
    data_out_ready = 0;
    arst_n = 0;
    #5;
    arst_n = 1;
    #5;
  endtask

  always @(posedge clk_i) begin
    if (data_in_valid && data_in_ready) begin
      cnt++;
      data_queue.push_back(data_in);
    end
    if (data_out_valid && data_out_ready) begin
      cnt--;
      if (data_queue.pop_front() == data_out) begin
        pass++;
      end else begin
        fail++;
      end
    end
  end

  initial begin
    apply_reset();
    start_clock();

    repeat (50) begin
      @(posedge clk_i);
      data_in <= $random();
      data_in_valid <= !($urandom_range(0, 1));
      data_out_ready <= !($urandom_range(0, 5));
    end

    @(posedge clk_i);
    data_in_valid  <= '0;
    data_out_ready <= '1;

    while (cnt > 0) @(posedge clk_i);

    repeat (2) @(posedge clk_i);

    $display("%0d/%0d PASSED", pass, pass + fail);
    result_print(!fail, "TX_CNT");

    $finish();
  end
endmodule
