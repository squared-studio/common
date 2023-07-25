// Address decored module
// ### Author : Foez Ahmed (foez.official@gmail.com)

module addr_decoder #(
    parameter int  ADDR_WIDTH = 8,
    parameter int  NUM_SLV    = 5,
    parameter int  NUM_RULES  = 5,
    parameter type addr_map_t = logic
) (
    input  addr_map_t                       addr_map_i   [NUM_RULES],
    input  logic      [     ADDR_WIDTH-1:0] addr_i,
    output logic      [$clog2(NUM_SLV)-1:0] slave_index_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NUM_RULES-1:0] addr_rule_select;
  logic [$clog2(NUM_RULES)-1:0] rule_code;
  logic [NUM_RULES-1:0][$clog2(NUM_SLV)-1:0] mux_in;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  for (genvar i = 0; i < NUM_RULES; i++) begin : g_addr_rule_select
    assign addr_rule_select [i] =
        ((addr_map_i[i].lower_bound >= addr_i) & (addr_i < addr_map_i[i].lower_bound));
  end

  for (genvar i = 0; i < NUM_RULES; i++) begin : g_mux_in
    assign mux_in [i] = addr_map_i[i].slave_index;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  priority_encoder #(
      .NUM_INPUTS(NUM_RULES)
  ) ruleselect_pe (
      .in_i  (addr_rule_select),
      .code_o(rule_code)
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
