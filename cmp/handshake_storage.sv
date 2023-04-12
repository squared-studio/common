module handshake_storage #(
    parameter DEPTH = 4
) (
    input  logic clk_i,
    input  logic arst_n,    
    input  logic in_valid,
    output logic in_ready,
    output logic out_valid,
    input  logic out_ready
);

    logic [$clog2(DEPTH):0] cnt;

    logic in_hs;
    logic out_hs;
    
    assign in_ready  = (cnt != DEPTH);
    assign out_valid = (cnt != '0);

    assign in_hs  = in_valid  & in_ready;
    assign out_hs = out_valid & out_ready;

    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin 
            cnt <= '0;
        end
        else begin
            case ({in_hs, out_hs})
                2'b01 : cnt <= cnt - 1;
                2'b10 : cnt <= cnt + 1; 
            endcase
        end
    end
    
endmodule