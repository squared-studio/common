////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module apb_mem #(
    parameter ADDR_WIDTH = 0,
    parameter DATA_WIDTH = 0
) (
    input  wire                  clk,
    input  wire                  arst_n,
    input  wire                  psel,
    input  wire                  penable,
    input  wire [ADDR_WIDTH-1:0] paddr,
    input  wire                  pwrite,
    input  wire [DATA_WIDTH-1:0] pwdata,
    output wire [DATA_WIDTH-1:0] prdata,
    output wire                  pready
);

    enum int { IDLE, SETUP, ACCESS} state;

    reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];
    reg [DATA_WIDTH-1:0] rdata;
    reg                  ready;

    assign prdata = (state==ACCESS) ? rdata : 'z;
    assign pready = (state==ACCESS) ? ready : 'z;

    assign rdata = mem [paddr];

    always_ff @(posedge clk or negedge arst_n) begin
        
        if (~arst_n) begin // RESET
            state <= IDLE;
            ready <= '0;
        end

        else begin
            if (psel) begin
                case (state)
                    default : begin
                        state <= IDLE;
                        ready <= '0;
                    end

                    IDLE: begin
                        if (psel & ~penable) begin
                            state <= SETUP;
                            ready <= '0;
                        end
                    end

                    SETUP: begin
                        if (penable) begin
                        state <= ACCESS;
                            if (pwrite) begin
                                mem [paddr] <= pwdata;
                            end
                        ready <= '1;
                        end
                    end

                    ACCESS: begin
                        if (~psel) begin
                            state <= IDLE;
                            ready <= '0;
                        end
                        else if (~penable) begin
                            state <= SETUP;
                            ready <= '0;
                        end
                    end

                endcase
            end
            else begin
                state <= IDLE;
                ready <= '0;
            end
        end

    end

endmodule