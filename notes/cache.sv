/*
Author : Foez Ahmed (foez.official@gmail.com)
This file is part of squared-studio:common
Copyright (c) 2025 squared-studio
Licensed under the MIT License
See LICENSE file in the project root for full license information
*/

module cache #(
    parameter int ADDR_WIDTH = 8,
    parameter int DATA_WIDTH = 64
) (
    input  logic [ADDR_WIDTH-1:0] wr_addr_i,
    input  logic [           1:0] wr_size_i,
    input  logic                  wr_data_i,
    input  logic                  wr_valid_i,
    output logic                  wr_ready_o,

    output logic wr_done_o,

    input  logic [ADDR_WIDTH-1:0] rd_addr_i,
    input  logic [           1:0] rd_size_i,
    input  logic                  rd_valid_i,
    output logic                  rd_ready_o,

    output logic rd_data_o,
    output logic rd_done_o
);

endmodule
