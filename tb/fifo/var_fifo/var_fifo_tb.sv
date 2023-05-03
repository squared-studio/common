module var_fifo_tb;

    `include "tb_essentials.sv"

    // Parameters
    localparam  ELEM_WIDTH = 4;
    localparam  NUM_ELEM   = 4;
    localparam  FIFO_DEPTH = 8;

    // Ports
    logic                                clk_i;
    logic                                arst_n;
    logic [$clog2(NUM_ELEM+1)-1:0]       data_in_num_lanes;
    logic [$clog2(NUM_ELEM)-1:0]         data_in_start_lane;
    logic                                data_in_req_valid;
    logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_in;
    logic                                data_in_valid;
    logic                                data_in_ready;
    logic [$clog2(NUM_ELEM+1)-1:0]       data_out_num_lanes;
    logic [$clog2(NUM_ELEM)-1:0]         data_out_start_lane;
    logic                                data_out_req_valid;
    logic [NUM_ELEM-1:0][ELEM_WIDTH-1:0] data_out;
    logic                                data_out_valid;
    logic                                data_out_ready;
    logic [$clog2(FIFO_DEPTH+1)-1:0]     space_available;
    logic [$clog2(FIFO_DEPTH+1)-1:0]     elem_available;

    var_fifo 
    #(
        .ELEM_WIDTH ( ELEM_WIDTH ),
        .NUM_ELEM   ( NUM_ELEM   ),
        .FIFO_DEPTH ( FIFO_DEPTH )
    )
    var_fifo_dut (
        .clk_i (clk_i ),
        .arst_n (arst_n ),
        .data_in_num_lanes (data_in_num_lanes ),
        .data_in_start_lane (data_in_start_lane ),
        .data_in_req_valid (data_in_req_valid ),
        .data_in (data_in ),
        .data_in_valid (data_in_valid ),
        .data_in_ready (data_in_ready ),
        .data_out_num_lanes (data_out_num_lanes ),
        .data_out_start_lane (data_out_start_lane ),
        .data_out_req_valid (data_out_req_valid ),
        .data_out (data_out ),
        .data_out_valid (data_out_valid ),
        .data_out_ready (data_out_ready ),
        .space_available (space_available ),
        .elem_available  ( elem_available)
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

    task apply_reset ();
        #100;
        arst_n = 0;
        clk_i   = '1;
        data_in_start_lane  = '0;
        data_in_num_lanes   = '0;
        data_in_valid       = '0;
        data_in             = '0;
        data_out_start_lane = '0;
        data_out_num_lanes  = '0;
        data_out_ready      = '0;
        #100;
        arst_n = 1;
        #100;
    endtask

    initial begin
        apply_reset();
        start_clock();
        repeat (5) @ (posedge clk_i);

        for (int i = 0; i < NUM_ELEM; i++) begin
            for (int j = 0; j < (NUM_ELEM+1); j++) begin
                data_in_start_lane = i;
                data_in_num_lanes  = j;
                @ (posedge clk_i);        
            end
        end

        repeat (20) @ (posedge clk_i);

        data_in <= 'hdcba;
        data_in_start_lane <= 1;
        data_in_num_lanes  <= 2;
        data_in_valid <= '1;
        @ (posedge clk_i);
        data_in <= 'h89fe;
        data_in_start_lane <= 1;
        data_in_num_lanes  <= 3;
        data_in_valid <= '1;
        @ (posedge clk_i);
        data_in <= 'h4567;
        data_in_start_lane <= 0;
        data_in_num_lanes  <= 3;
        data_in_valid <= '1;
        @ (posedge clk_i);
        data_in_valid <= '0;

        repeat (20) @ (posedge clk_i);

        for (int i = 0; i < NUM_ELEM; i++) begin
            for (int j = 0; j < (NUM_ELEM+1); j++) begin
                data_out_start_lane = i;
                data_out_num_lanes  = j;
                @ (posedge clk_i);        
            end
        end

        repeat (20) @ (posedge clk_i);

        @ (posedge clk_i);
        data_out_start_lane <= 0;
        data_out_num_lanes  <= 0;
        data_out_ready <= '1;
        @ (posedge clk_i);
        data_out_start_lane <= 0;
        data_out_num_lanes  <= 1;
        data_out_ready <= '1;
        @ (posedge clk_i);
        data_out_start_lane <= 2;
        data_out_num_lanes  <= 2;
        data_out_ready <= '1;
        @ (posedge clk_i);
        data_out_start_lane <= 0;
        data_out_num_lanes  <= 4;
        data_out_ready <= '1;
        @ (posedge clk_i);
        data_out_ready <= '0;l

        repeat (20) @ (posedge clk_i);

        $finish;

    end

endmodule
