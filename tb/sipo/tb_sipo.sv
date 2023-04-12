module tb_sipo;
    initial begin
        $dumpfile("raw.vcd");
        $dumpvars;
        $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
    end
    final begin
        $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
    end

    localparam  SERIAL_WIDTH = 4;
    localparam  DEPTH = 5;
    localparam  LEFT_SHIFT = 0;
    localparam  PARALLEL_WIDTH = SERIAL_WIDTH * DEPTH;

    logic                      clk_i    ; 
    logic                      arst_n   ; 
    logic                      en       ; 
    logic [SERIAL_WIDTH-1:0]   data_in  ; 
    logic [PARALLEL_WIDTH-1:0] data_out ; 

    sipo #(
        .SERIAL_WIDTH(SERIAL_WIDTH),
        .DEPTH(DEPTH),
        .LEFT_SHIFT(LEFT_SHIFT)
    ) sipo_dut (
        .clk_i    ( clk_i    ),
        .arst_n   ( arst_n   ),
        .en       ( en       ),
        .data_in  ( data_in  ),
        .data_out ( data_out )
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
        clk_i = 1;
        data_in = 0;
        en = 0;
        arst_n = 0; #5;
        arst_n = 1; #5;
    endtask

    initial begin
        apply_reset();
        start_clock();

        repeat(8) begin
            @ (posedge clk_i);
            data_in <= $random();
            en <= !($urandom_range(0,5));
        end

        @ (posedge clk_i);
        en      <= '1;
        data_in <= '1;
        
        repeat(20) @ (posedge clk_i);

        $finish();
    end
endmodule