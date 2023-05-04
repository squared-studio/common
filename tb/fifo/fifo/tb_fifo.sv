////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module tb_fifo;

    `include "tb_essentials.sv"

    localparam DATA_WIDTH = 4;
    localparam DEPTH      = 8;

    int err;
    int in_cnt;
    int out_cnt;

    logic                  clk_i         ; 
    logic                  arst_n        ; 
    logic [DATA_WIDTH-1:0] data_in       ; 
    logic                  data_in_valid ; 
    logic                  data_in_ready ; 
    logic [DATA_WIDTH-1:0] data_out      ; 
    logic                  data_out_valid; 
    logic                  data_out_ready; 

    fifo #(
        .DATA_WIDTH ( DATA_WIDTH ),
        .DEPTH      ( DEPTH      )
    ) u_fifo (
        .clk_i          ( clk_i          ),
        .arst_n         ( arst_n         ),
        .data_in        ( data_in        ),
        .data_in_valid  ( data_in_valid  ),
        .data_in_ready  ( data_in_ready  ),
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
        join_none
        repeat (2) @ (posedge clk_i);
    endtask

    logic [DATA_WIDTH-1:0] data_queue [$];

    task apply_reset ();
        data_queue.delete();
        err  = 0;
        in_cnt = 0;
        out_cnt = 0;
        clk_i = 1;
        data_in = 0;
        data_in_valid = 0;
        data_out_ready = 0;
        #5;
        arst_n = 0;
        #5;
        arst_n = 1;
        #5;
    endtask

    always @(posedge clk_i) begin
        if (data_in_valid && data_in_ready) begin
            in_cnt++;
            data_queue.push_back(data_in);
        end
        if (data_out_valid && data_out_ready) begin
            out_cnt++;
            if (data_queue.pop_front() != data_out) begin
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
        start_clock();

        data_in_valid <= '1;
        data_out_ready <= '0;
        for (int i=0; i<DEPTH; i++) begin
            prev_data_in_ready = data_in_ready;
            @ (posedge clk_i);
        end

        @ (posedge clk_i);
        data_in_valid <= '0;
        
        result_print (~data_in_ready & prev_data_in_ready, "sync reset");
        
        arst_n <= '0; @ (posedge clk_i);
        arst_n <= '1; @ (posedge clk_i);
        
        data_in_valid <= '1;
        for (int i=0; i<DEPTH; i++) begin
            prev_data_in_ready = data_in_ready;
            @ (posedge clk_i);
        end

        @ (posedge clk_i);
        data_in_valid <= '0;
        
        result_print (~data_in_ready & prev_data_in_ready, "data_in_ready LOW at exact full");
        
        data_out_ready <= '1;
        for (int i=0; i<DEPTH; i++) begin
            prev_data_out_valid = data_out_valid;
            @ (posedge clk_i);
        end

        @ (posedge clk_i);
        data_out_ready <= '0;
        
        result_print (~data_out_valid & prev_data_out_valid, "data_out_valid LOW at exact empty");
        
        repeat (2) @ (posedge clk_i);

        data_in_valid  <= 0;
        data_out_ready <= 0;

        @ (posedge clk_i);
        prev_data_in_valid  = data_in_valid;
        prev_data_in_ready  = data_in_ready;
        prev_data_out_valid = data_out_valid;
        prev_data_out_ready = data_out_ready;
        data_in_valid  <= '1;
        data_out_ready <= '1;
        @ (posedge clk_i);

        result_print ( 
              ~prev_data_in_valid 
            & prev_data_in_ready 
            & ~prev_data_out_valid
            & ~prev_data_out_ready
            & data_in_valid 
            & data_in_ready 
            & data_out_valid
            & data_out_ready
        , "direct bypass when EMPTY");

        data_out_ready <= 0;

        data_in_valid  <= 1;
        do @ (posedge clk_i);
        while (data_in_ready);
        data_in_valid  <= 0;

        @ (posedge clk_i);
        prev_data_in_valid  = data_in_valid;
        prev_data_in_ready  = data_in_ready;
        prev_data_out_valid = data_out_valid;
        prev_data_out_ready = data_out_ready;
        data_in_valid  <= '1;
        data_out_ready <= '1;
        @ (posedge clk_i);

        result_print ( 
              ~prev_data_in_valid 
            & ~prev_data_in_ready 
            & prev_data_out_valid
            & ~prev_data_out_ready
            & data_in_valid 
            & data_in_ready 
            & data_out_valid
            & data_out_ready
        , "both side handshake when FULL");

        data_queue.delete();
        data_in_valid  <= 0;
        data_out_ready <= 0;
        err = 0;
        in_cnt = 0;
        out_cnt = 0;
        arst_n <= 0; @ (posedge clk_i);
        arst_n <= 1; @ (posedge clk_i);

        while (out_cnt < 100) begin
            data_in        <= $random;
            data_in_valid  <= ($urandom_range(0, 9)>8);
            data_out_ready <= ($urandom_range(0, 9)>0);
            @ (posedge clk_i);
        end
        
        
        while (in_cnt < 200) begin
            data_in        <= $random;
            data_in_valid  <= $urandom_range(0, 1);
            data_out_ready <= $urandom_range(0, 1);
            @ (posedge clk_i);
        end
        
        data_in_valid  <= 0;
        data_out_ready <= 1;
        while (out_cnt < 200) begin
            @ (posedge clk_i);
        end
        data_out_ready <= 0;

        result_print (err == 0, "dataflow");

        $finish();
    end
endmodule