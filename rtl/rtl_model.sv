////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    Author : ... (...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

module rtl_model #(
    parameter int DataWidth = 8,
    parameter int Depth = 5
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [DataWidth-1:0] data_in_i,
    input  logic                 data_in_valid_i,
    output logic                 data_in_ready_o,

    output logic [DataWidth-1:0] data_out_o,
    output logic                 data_out_valid_o,
    input  logic                 data_out_ready_i
);














endmodule
