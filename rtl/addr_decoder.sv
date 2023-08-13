// Address decored module
// ### Author : Foez Ahmed (foez.official@gmail.com)

`include "default_param_pkg.sv"

module addr_decoder #(
    parameter int ADDR_WIDTH = default_param_pkg::ADDR_DECODER_ADDR_WIDTH,  // address width
    parameter int NUM_SLV = default_param_pkg::ADDR_DECODER_NUM_SLV,  // num slave
    parameter int NUM_RULES = default_param_pkg::ADDR_DECODER_NUM_RULES,  // num address map rules
    parameter type addr_map_t = default_param_pkg::addr_decoder_addr_map_t,  // address map type
    parameter addr_map_t ADDR_MAP[NUM_RULES] = default_param_pkg::ADDR_MAP  // address map
) (
    input  logic [     ADDR_WIDTH-1:0] addr_i,         // address input
    output logic [$clog2(NUM_SLV)-1:0] slave_index_o,  // slave index output
    output logic                       addr_found_o    // slave index valid
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_RULES-1:0] addr_rule_select;  // falling in rule

  logic [$clog2(NUM_RULES)-1:0] rule_code;  // prioritized rule

  logic [NUM_RULES-1:0][$clog2(NUM_SLV)-1:0] mux_in;  // address map slave index mux

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
