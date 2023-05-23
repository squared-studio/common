// ### Author : Foez Ahmed (foez.official@gmail.com)

module tb_pipeline;

  `include "vip/tb_ess.sv"

  localparam int ElemWidth = 8;
  localparam int NumStages = 8;

  int                   pass;
  int                   fail;
  int                   cnt;

  logic                 clk_i;
  logic                 arst_ni;
  logic [ElemWidth-1:0] elem_in_i;
  logic                 elem_in_valid_i;
  logic                 elem_in_ready_o;
  logic [ElemWidth-1:0] elem_out_o;
  logic                 elem_out_valid_o;
  logic                 elem_out_ready_i;

  pipeline #(
      .ElemWidth(ElemWidth),
      .NumStages(NumStages)
  ) u_pipeline (
      .clk_i           (clk_i),
      .arst_ni         (arst_ni),
      .elem_in_i       (elem_in_i),
      .elem_in_valid_i (elem_in_valid_i),
      .elem_in_ready_o (elem_in_ready_o),
      .elem_out_o      (elem_out_o),
      .elem_out_valid_o(elem_out_valid_o),
      .elem_out_ready_i(elem_out_ready_i)
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

  logic [ElemWidth-1:0] elem_queue[$];

  task static apply_reset();
    elem_queue.delete();
    pass = 0;
    fail = 0;
    cnt = 0;
    clk_i = 1;
    elem_in_i = 0;
    elem_in_valid_i = 0;
    elem_out_ready_i = 0;
    arst_ni = 0;
    #5;
    arst_ni = 1;
    #5;
  endtask

  always @(posedge clk_i) begin
    if (elem_in_valid_i && elem_in_ready_o) begin
      cnt++;
      elem_queue.push_back(elem_in_i);
    end
    if (elem_out_valid_o && elem_out_ready_i) begin
      cnt--;
      if (elem_queue.pop_front() == elem_out_o) begin
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
      elem_in_i <= $urandom();
      elem_in_valid_i <= !($urandom_range(0, 1));
      elem_out_ready_i <= !($urandom_range(0, 5));
    end

    @(posedge clk_i);
    elem_in_valid_i  <= '0;
    elem_out_ready_i <= '1;

    while (cnt > 0) @(posedge clk_i);

    repeat (2) @(posedge clk_i);

    $display("%0d/%0d PASSED", pass, pass + fail);
    result_print(!fail, "TX_CNT");

    $finish();
  end

endmodule
