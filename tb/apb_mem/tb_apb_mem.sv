////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module tb_apb_mem;

    initial begin
        $dumpfile("raw.vcd");
        $dumpvars;
        $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
    end
    final begin
        $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
    end

    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 8;

    logic                  clk;
    logic                  arst_n;
    logic [3:0]            psel;
    logic                  penable;
    logic [ADDR_WIDTH-1:0] paddr;
    logic                  pwrite;
    logic [DATA_WIDTH-1:0] pwdata;
    wire  [DATA_WIDTH-1:0] prdata;
    wire                   pready;

    generate 
        for (genvar i = 0; i < 4; i++) begin
            apb_mem #(
                .ADDR_WIDTH ( ADDR_WIDTH ),
                .DATA_WIDTH ( DATA_WIDTH )
            ) u_apb_mem (
                .clk(clk),
                .arst_n(arst_n),
                .psel(psel[i]),
                .penable(penable),
                .paddr(paddr),
                .pwrite(pwrite),
                .pwdata(pwdata),
                .prdata(prdata),
                .pready(pready)
            );
        end
    endgenerate

    

    task apply_reset();
        arst_n = '1;
        clk    = '1;
        #100;
        arst_n = '0;
        psel = 0;
        penable = 0;
        paddr = 0;
        pwrite = 0;
        pwdata = 0;
        #100;
        arst_n = '1;
        #100;
    endtask

    task start_clock();
        fork
            forever begin
                clk = 1; #5;
                clk = 0; #5;
            end
        join_none
        repeat (2) @ (posedge clk);
    endtask

    task just_write (byte sel, byte addr, byte data);
        @ (posedge clk);
        paddr      <= addr;
        pwrite     <= '1;
        pwdata     <= data;
        psel [sel] <= '1;
        penable    <= '0;

        @ (posedge clk);
        penable <= '1;

        do @ (posedge clk);
        while (pready !== '1);
        
        @ (posedge clk);
        penable <= '0;

        @ (posedge clk);
        psel    <= '0;
    endtask

    task just_read (byte sel, byte addr);
        @ (posedge clk);
        paddr      <= addr;
        pwrite     <= '0;
        psel [sel] <= '1;
        penable    <= '0;

        @ (posedge clk);
        penable <= '1;

        do @ (posedge clk);
        while (pready !== '1);
        
        @ (posedge clk);
        penable <= '0;

        @ (posedge clk);
        psel    <= '0;
    endtask

    initial begin
        apply_reset();
        start_clock();
    
        just_write(0, 0,'hF0);
        just_write(1, 0,'he2);
        
        just_read(0, 0);
        just_read(1, 0);

        repeat (20) @ (posedge clk);
        $finish;
    end

endmodule