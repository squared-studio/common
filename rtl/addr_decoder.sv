/*
The `addr_decoder` module is a parameterized SystemVerilog module that decodes an input address to
select a slave device. The module uses a priority encoder and a multiplexer to select the
appropriate slave based on the input address.
Author : Foez Ahmed (foez.official@gmail.com)
*/

`include "default_param_pkg.sv"

module addr_decoder #(
    // The width of the address input
    parameter int ADDR_WIDTH = default_param_pkg::ADDR_DECODER_ADDR_WIDTH,
    // The number of slave devices
    parameter int NUM_SLV = default_param_pkg::ADDR_DECODER_NUM_SLV,
    // The number of address map rules
    parameter int NUM_RULES = default_param_pkg::ADDR_DECODER_NUM_RULES,
    // The type of the address map
    parameter type addr_map_t = default_param_pkg::addr_decoder_addr_map_t,
    // The address map array
    parameter addr_map_t ADDR_MAP[NUM_RULES] = default_param_pkg::ADDR_MAP
) (
    // The input address. It is a logic vector of size `[ADDR_WIDTH-1:0]`
    input logic [ADDR_WIDTH-1:0] addr_i,

    // The output slave index. It is a logic vector of size `[$clog2(NUM_SLV)-1:0]`
    output logic [$clog2(NUM_SLV)-1:0] slave_index_o,
    // A logic output that indicates if the address was found in the address map
    output logic                       addr_found_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  // A logic array of size `[NUM_RULES-1:0]` that indicates if the input address falls within a rule
  logic [NUM_RULES-1:0] addr_rule_select;
  // A logic vector of size `[$clog2(NUM_RULES)-1:0]` that holds the prioritized rule code
  logic [$clog2(NUM_RULES)-1:0] rule_code;
  // A 2D logic array of size `[NUM_RULES-1:0][$clog2(NUM_SLV)-1:0]` that holds the slave indices
  // for the multiplexer inputs
  logic [NUM_RULES-1:0][$clog2(NUM_SLV)-1:0] mux_in;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_RULES; i++) begin : g_addr_rule_select
    assign addr_rule_select [i] =
        ((ADDR_MAP[i].lower_bound >= addr_i) & (addr_i < ADDR_MAP[i].lower_bound));
  end

  for (genvar i = 0; i < NUM_RULES; i++) begin : g_mux_in
    assign mux_in[i] = ADDR_MAP[i].slave_index;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  priority_encoder #(
      .NUM_WIRE(NUM_RULES),
      .HIGH_INDEX_PRIORITY(0)
  ) ruleselect_pe (
      .d_i(addr_rule_select),
      .addr_o(rule_code),
      .addr_valid_o(addr_found_o)
  );

  mux #(
      .ELEM_WIDTH($clog2(NUM_SLV)),
      .NUM_ELEM  (NUM_RULES)
  ) mux_dut (
      .sel_i(rule_code),
      .inputs_i(mux_in),
      .output_o(slave_index_o)
  );

endmodule
