module fixed_priority_arbiter_tb;

    // Parameters

    localparam  NUM_REQ = 4;

    // Ports
    reg clk_i;
    reg [NUM_REQ-1:0] req;
    wire [NUM_REQ-1:0] gnt;

    fixed_priority_arbiter 
    #(
    .NUM_REQ (
    NUM_REQ )
    )
    fixed_priority_arbiter_dut (
    .req (req ),
    .gnt  ( gnt)
    );

    initial begin
        int PASS;
        int FAIL;

        fork
            forever begin
                clk_i = 1; #5;
                clk_i = 0; #5;
            end
        join_none

        fork
            
            forever @ (negedge clk_i) begin
                bit cont;
                cont = 1;
                for (int i = 0; (i < NUM_REQ) && cont; i++) begin
                    if (req[i] == '1) begin
                        cont=0; 
                        if (gnt == (1 << i)) begin
                            $write("PASSED: ");   
                            PASS++;                         
                        end 
                        else begin
                            $write("FAILED: ");
                            FAIL++;
                        end
                        $display("%b %b", req, gnt);
                    end
                end

            end

            begin
                for (int i = 0; i < (2**NUM_REQ); i++) begin
                    @ (posedge clk_i);
                    req <= i;
                end
                @ (posedge clk_i);
            end 

        join_any

        $display("%0d", PASS, "/%0d", PASS+FAIL, " PASSED");
        $finish;
    end

endmodule
