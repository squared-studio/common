module tb_model;
    initial begin
        $dumpfile("raw.vcd");
        $dumpvars;
        $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
    end
    final begin
        $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
    end

    bit clk_i  = 1;
    bit arst_n = 1;

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
        #100;
        arst_n = 1;
        #100;
    endtask

    initial begin
        apply_reset();
        start_clock();
        
        if (1) $write("%c[1;32m[PASS]%c[0m", 27, 27); else $write("%c[1;31m[FAIL]%c[0m", 27, 27);
        $display("this is a PASS");
        if (0) $write("%c[1;32m[PASS]%c[0m", 27, 27); else $write("%c[1;31m[FAIL]%c[0m", 27, 27);
        $display("and this is a FAIL");    

        $finish;
    end

endmodule