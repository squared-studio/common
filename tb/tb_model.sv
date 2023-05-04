////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
    DESIGNER : <DesignerNameHere>
    MODULE   : <Module description>
*/
module tb_model;

    `include "tb_essentials.sv"

    bit clk_i  = 1;
    bit arst_n = 1;

    task static start_clock ();
        fork
            forever begin
                clk_i = 1; #5;
                clk_i = 0; #5;
            end
        join_none
        repeat (2) @ (posedge clk_i);
    endtask

    task static apply_reset ();
        #100;
        arst_n = 0;
        #100;
        arst_n = 1;
        #100;
    endtask

    initial begin
        apply_reset();
        start_clock();

        result_print (1, "This is a PASS");
        result_print (0, "And this is a FAIL");

        $finish;

    end

endmodule
