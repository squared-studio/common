////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module var_fifo_tb;

  `include "vip/tb_ess.sv"

  // Parameters
  localparam int ElemWidth = 4;
  localparam int NumElem = 4;
  localparam int FifoDepth = 8;

  // Ports
  logic                                          clk_i;
  logic                                          arst_ni;
  logic [  $clog2(NumElem+1)-1:0]                data_in_num_lanes_i;
  logic [    $clog2(NumElem)-1:0]                data_in_start_lane_i;
  logic                                          data_in_req_valid_o;
  logic [            NumElem-1:0][ElemWidth-1:0] data_in_i;
  logic                                          data_in_valid_i;
  logic                                          data_in_ready_o;
  logic [  $clog2(NumElem+1)-1:0]                data_out_num_lanes_i;
  logic [    $clog2(NumElem)-1:0]                data_out_start_lane_i;
  logic                                          data_out_req_valid_o;
  logic [            NumElem-1:0][ElemWidth-1:0] data_out_o;
  logic                                          data_out_valid_o;
  logic                                          data_out_ready_i;
  logic [$clog2(FifoDepth+1)-1:0]                space_available_o;
  logic [$clog2(FifoDepth+1)-1:0]                elem_available_o;

  var_fifo #(
      .ElemWidth(ElemWidth),
      .NumElem  (NumElem),
      .FifoDepth(FifoDepth)
  ) var_fifo_dut (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .data_in_num_lanes_i(data_in_num_lanes_i),
      .data_in_start_lane_i(data_in_start_lane_i),
      .data_in_req_valid_o(data_in_req_valid_o),
      .data_in_i(data_in_i),
      .data_in_valid_i(data_in_valid_i),
      .data_in_ready_o(data_in_ready_o),
      .data_out_num_lanes_i(data_out_num_lanes_i),
      .data_out_start_lane_i(data_out_start_lane_i),
      .data_out_req_valid_o(data_out_req_valid_o),
      .data_out_o(data_out_o),
      .data_out_valid_o(data_out_valid_o),
      .data_out_ready_i(data_out_ready_i),
      .space_available_o(space_available_o),
      .elem_available_o(elem_available_o)
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

  task static apply_reset();
    #100;
    arst_ni               = 0;
    clk_i                 = '1;
    data_in_start_lane_i  = '0;
    data_in_num_lanes_i   = '0;
    data_in_valid_i       = '0;
    data_in_i             = '0;
    data_out_start_lane_i = '0;
    data_out_num_lanes_i  = '0;
    data_out_ready_i      = '0;
    #100;
    arst_ni = 1;
    #100;
  endtask

  initial begin
    apply_reset();
    start_clock();
    repeat (5) @(posedge clk_i);

    for (int i = 0; i < NumElem; i++) begin
      for (int j = 0; j < (NumElem + 1); j++) begin
        data_in_start_lane_i = i;
        data_in_num_lanes_i  = j;
        @(posedge clk_i);
      end
    end

    repeat (20) @(posedge clk_i);

    data_in_i <= 'hdcba;
    data_in_start_lane_i <= 1;
    data_in_num_lanes_i <= 2;
    data_in_valid_i <= '1;
    @(posedge clk_i);
    data_in_i <= 'h89fe;
    data_in_start_lane_i <= 1;
    data_in_num_lanes_i <= 3;
    data_in_valid_i <= '1;
    @(posedge clk_i);
    data_in_i <= 'h4567;
    data_in_start_lane_i <= 0;
    data_in_num_lanes_i <= 3;
    data_in_valid_i <= '1;
    @(posedge clk_i);
    data_in_valid_i <= '0;

    repeat (20) @(posedge clk_i);

    for (int i = 0; i < NumElem; i++) begin
      for (int j = 0; j < (NumElem + 1); j++) begin
        data_out_start_lane_i = i;
        data_out_num_lanes_i  = j;
        @(posedge clk_i);
      end
    end

    repeat (20) @(posedge clk_i);

    @(posedge clk_i);
    data_out_start_lane_i <= 0;
    data_out_num_lanes_i <= 0;
    data_out_ready_i <= '1;
    @(posedge clk_i);
    data_out_start_lane_i <= 0;
    data_out_num_lanes_i <= 1;
    data_out_ready_i <= '1;
    @(posedge clk_i);
    data_out_start_lane_i <= 2;
    data_out_num_lanes_i <= 2;
    data_out_ready_i <= '1;
    @(posedge clk_i);
    data_out_start_lane_i <= 0;
    data_out_num_lanes_i <= 4;
    data_out_ready_i <= '1;
    @(posedge clk_i);
    data_out_ready_i <= '0;

    repeat (20) @(posedge clk_i);

    $finish;

  end

endmodule
