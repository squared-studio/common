// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

module clk_div #(
    parameter int DIV_WIDTH = 3
) (
    input logic arst_ni,
    input logic clk_i,
    input logic [DIV_WIDTH-1:0] div_i,
    output logic clk_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic no_div;
  logic clk_inv;

  logic [DIV_WIDTH-2:0] clk_count;
  logic [DIV_WIDTH-2:0] high_count;
  logic [DIV_WIDTH-2:0] low_count;
  logic clk_state_internal;
  logic clk_dff;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign no_div = ~(|high_count);
  assign clk_inv = ~clk_i;

  assign high_count = div_i[DIV_WIDTH-1:1];
  assign low_count = div_i[DIV_WIDTH-1:1] + div_i[0];

  assign clk_o = no_div ? clk_i : (div_i[0] ? (clk_state_internal | clk_dff) : clk_state_internal);

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      clk_state_internal <= '0;
      clk_count <= '0;
    end else begin
      if (clk_state_internal) begin
        if (clk_count == (high_count - 1)) begin
          clk_count <= '0;
          clk_state_internal <= '0;
        end else begin
          clk_count <= clk_count + 1;
        end
      end else begin
        if (clk_count == (low_count - 1)) begin
          clk_count <= '0;
          clk_state_internal <= '1;
        end else begin
          clk_count <= clk_count + 1;
        end
      end
    end
  end

  always_ff @(posedge clk_inv or negedge arst_ni) begin
    if (~arst_ni) begin
      clk_dff <= '0;
    end else begin
      clk_dff <= clk_state_internal;
    end
  end


  //}}}

endmodule
