// A simple up down counter that counts up to MAX_COUNT
// ### Author : Md. Mohiuddin Reyad (mreyad30207@gmail.com)

module counter #(
    parameter int                         MAX_COUNT   = 25,  // max value of count
    parameter bit [$clog2(MAX_COUNT)-1:0] RESET_VALUE = '0,
    parameter bit                         UP_AND_DOWN = 1
) (
    input  logic                         clk_i,
    input  logic                         arstn_i,
    input  logic                         up_i,
    input  logic                         down_i,
    output logic [$clog2(MAX_COUNT)-1:0] count_o
);



endmodule
