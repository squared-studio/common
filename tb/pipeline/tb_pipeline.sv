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

  localparam int DataWidth = 8;
  localparam int NumStages = 8;

  int                   pass;
  int                   fail;
  int                   cnt;

  logic                 clk_i;
  logic                 arst_ni;
  logic [DataWidth-1:0] data_in_i;
  logic                 data_in_valid_i;
  logic                 data_in_ready_o;
  logic [DataWidth-1:0] data_out_o;
  logic                 data_out_valid_o;
  logic                 data_out_ready_i;

  pipeline #(
      .DataWidth(DataWidth),
      .NumStages(NumStages)
  ) u_pipeline (
      .clk_i           (clk_i),
      .arst_ni         (arst_ni),
      .data_in_i       (data_in_i),
      .data_in_valid_i (data_in_valid_i),
      .data_in_ready_o (data_in_ready_o),
      .data_out_o      (data_out_o),
      .data_out_valid_o(data_out_valid_o),
      .data_out_ready_i(data_out_ready_i)
  );

  task static start_clock();
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

  logic [DataWidth-1:0] data_queue[$];

  task static apply_reset();
    data_queue.delete();
    pass = 0;
    fail = 0;
    cnt = 0;
    clk_i = 1;
    data_in_i = 0;
    data_in_valid_i = 0;
    data_out_ready_i = 0;
    arst_ni = 0;
    #5;
    arst_ni = 1;
    #5;
  endtask

  always @(posedge clk_i) begin
    if (data_in_valid_i && data_in_ready_o) begin
      cnt++;
      data_queue.push_back(data_in_i);
    end
    if (data_out_valid_o && data_out_ready_i) begin
      cnt--;
      if (data_queue.pop_front() == data_out_o) begin
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
      data_in_i <= $urandom();
      data_in_valid_i <= !($urandom_range(0, 1));
      data_out_ready_i <= !($urandom_range(0, 5));
    end

    @(posedge clk_i);
    data_in_valid_i  <= '0;
    data_out_ready_i <= '1;

    while (cnt > 0) @(posedge clk_i);

    repeat (2) @(posedge clk_i);

    $display("%0d/%0d PASSED", pass, pass + fail);
    result_print(!fail, "TX_CNT");

    $finish();
  end

endmodule
