////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module fifo_tb;

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // IMPORTS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // bring in the testbench essentials functions and macros
    `include "tb_essentials.sv"

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // LOCALPARAMS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    localparam int DataWidth = 4;
    localparam int Depth     = 8;

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // SIGNALS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // generates static task start_clk_i with tHigh:3 tLow:7
    `CREATE_CLK(clk_i, 3, 7)
    logic arst_n = 1;

    logic                 arst_ni         ;
    logic [DataWidth-1:0] data_in_i       ;
    logic                 data_in_valid_i ;
    logic                 data_in_ready_o ;
    logic [DataWidth-1:0] data_out_o      ;
    logic                 data_out_valid_o;
    logic                 data_out_ready_i;

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ////////////////////////////////////////////////////////////////////////////////////////////////

    int err;
    int in_cnt;
    int out_cnt;

    logic [DataWidth-1:0] data_queue [$];

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // RTLS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    fifo #(
        .DataWidth ( DataWidth ),
        .Depth     ( Depth     )
    ) u_fifo (
        .clk_i            ( clk_i            ),
        .arst_ni          ( arst_ni          ),
        .data_in_i        ( data_in_i        ),
        .data_in_valid_i  ( data_in_valid_i  ),
        .data_in_ready_o  ( data_in_ready_o  ),
        .data_out_o       ( data_out_o       ),
        .data_out_valid_o ( data_out_valid_o ),
        .data_out_ready_i ( data_out_ready_i )
    );

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // METHODS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    task static apply_reset ();
        data_queue.delete();
        err  = 0;
        in_cnt = 0;
        out_cnt = 0;
        clk_i = 1;
        data_in_i = 0;
        data_in_valid_i = 0;
        data_out_ready_i = 0;
        #5;
        arst_ni = 0;
        #5;
        arst_ni = 1;
        #5;
    endtask

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // PROCEDURALS
    ////////////////////////////////////////////////////////////////////////////////////////////////

    always @(posedge clk_i) begin
        if (data_in_valid_i && data_in_ready_o) begin
            in_cnt++;
            data_queue.push_back(data_in_i);
        end
        if (data_out_valid_o && data_out_ready_i) begin
            out_cnt++;
            if (data_queue.pop_front() != data_out_o) begin
                err++;
            end
        end
    end

    initial begin
        bit prev_data_in_valid;
        bit prev_data_in_ready;
        bit prev_data_out_valid;
        bit prev_data_out_ready;

        apply_reset();
        start_clk_i();

        data_in_valid_i <= '1;
        data_out_ready_i <= '0;
        for (int i=0; i<Depth; i++) begin
            prev_data_in_ready = data_in_ready_o;
            @ (posedge clk_i);
        end

        @ (posedge clk_i);
        data_in_valid_i <= '0;

        result_print (~data_in_ready_o & prev_data_in_ready, "sync reset");

        arst_ni <= '0; @ (posedge clk_i);
        arst_ni <= '1; @ (posedge clk_i);

        data_in_valid_i <= '1;
        for (int i=0; i<Depth; i++) begin
            prev_data_in_ready = data_in_ready_o;
            @ (posedge clk_i);
        end

        @ (posedge clk_i);
        data_in_valid_i <= '0;

        result_print (~data_in_ready_o & prev_data_in_ready, "data_in_ready_o LOW at exact full");

        data_out_ready_i <= '1;
        for (int i=0; i<Depth; i++) begin
            prev_data_out_valid = data_out_valid_o;
            @ (posedge clk_i);
        end

        @ (posedge clk_i);
        data_out_ready_i <= '0;

        result_print (~data_out_valid_o & prev_data_out_valid,
         "data_out_valid_o LOW at exact empty");

        repeat (2) @ (posedge clk_i);

        data_in_valid_i  <= 0;
        data_out_ready_i <= 0;

        @ (posedge clk_i);
        prev_data_in_valid  = data_in_valid_i;
        prev_data_in_ready  = data_in_ready_o;
        prev_data_out_valid = data_out_valid_o;
        prev_data_out_ready = data_out_ready_i;
        data_in_valid_i  <= '1;
        data_out_ready_i <= '1;
        @ (posedge clk_i);

        result_print (
              ~prev_data_in_valid
            & prev_data_in_ready
            & ~prev_data_out_valid
            & ~prev_data_out_ready
            & data_in_valid_i
            & data_in_ready_o
            & data_out_valid_o
            & data_out_ready_i
        , "direct bypass when EMPTY");

        data_out_ready_i <= 0;

        data_in_valid_i  <= 1;
        do @ (posedge clk_i);
        while (data_in_ready_o);
        data_in_valid_i  <= 0;

        @ (posedge clk_i);
        prev_data_in_valid  = data_in_valid_i;
        prev_data_in_ready  = data_in_ready_o;
        prev_data_out_valid = data_out_valid_o;
        prev_data_out_ready = data_out_ready_i;
        data_in_valid_i  <= '1;
        data_out_ready_i <= '1;
        @ (posedge clk_i);

        result_print (
              ~prev_data_in_valid
            & ~prev_data_in_ready
            & prev_data_out_valid
            & ~prev_data_out_ready
            & data_in_valid_i
            & data_in_ready_o
            & data_out_valid_o
            & data_out_ready_i
        , "both side handshake when FULL");

        data_queue.delete();
        data_in_valid_i  <= 0;
        data_out_ready_i <= 0;
        err = 0;
        in_cnt = 0;
        out_cnt = 0;
        arst_ni <= 0; @ (posedge clk_i);
        arst_ni <= 1; @ (posedge clk_i);

        while (out_cnt < 100) begin
            data_in_i        <= $urandom;
            data_in_valid_i  <= ($urandom_range(0, 9)>8);
            data_out_ready_i <= ($urandom_range(0, 9)>0);
            @ (posedge clk_i);
        end

        while (in_cnt < 200) begin
            data_in_i        <= $urandom;
            data_in_valid_i  <= $urandom_range(0, 1);
            data_out_ready_i <= $urandom_range(0, 1);
            @ (posedge clk_i);
        end

        data_in_valid_i  <= 0;
        data_out_ready_i <= 1;
        while (out_cnt < 200) begin
            @ (posedge clk_i);
        end
        data_out_ready_i <= 0;

        result_print (err == 0, "dataflow");

        $finish();
    end

endmodule
