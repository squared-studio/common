/*
module piso #(
    parameter DATA_WIDTH  = 4,
    parameter NUM_OUTPUTS = 5,
    localparam PARA_WIDTH = DATA_WIDTH*NUM_OUTPUTS
) (
    input  logic clk_i,
    input  logic arst_n,
    input  logic en,
    input  logic [DATA_WIDTH-1:0] serial_in,
    output logic [PARA_WIDTH-1:0] parallel_out
);

    logic [NUM_OUTPUTS-1:0][DATA_WIDTH-1:0]  buff;

    assign parallel_out = buff;

    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
            buff <= '0;
        end
        else begin
            if (en) begin
                for (int i=0; i<NUM_OUTPUTS; i++) begin
                    if (i==INUM_OUTPUTS-1)) buff[i] <= serial_in;
                    else                    buff[i] <= buff[i-1];
                end
            end
        end
    end
    
endmodule
*/