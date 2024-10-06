
`ifndef COMMON_DEFAULT_PARAM_PKG_SV
`define COMMON_DEFAULT_PARAM_PKG_SV

package common_default_param_pkg;

  `include "addr_map.svh"
  parameter int ADDR_DECODER_SLV_INDEX_WIDTH = 4;
  parameter int ADDR_DECODER_ADDR_WIDTH = 32;
  parameter int ADDR_DECODER_NUM_RULES = 9;
  `ADDR_MAP_T(addr_decoder_addr_map_t, ADDR_DECODER_SLV_INDEX_WIDTH, ADDR_DECODER_ADDR_WIDTH)
  parameter addr_decoder_addr_map_t ADDR_MAP[ADDR_DECODER_NUM_RULES] = '{
      '{slave_index: 'h0, lower_bound: 'h0000_0000, upper_bound: 'h0000_1000},
      '{slave_index: 'h1, lower_bound: 'h0000_1000, upper_bound: 'h0000_2000},
      '{slave_index: 'h2, lower_bound: 'h0000_2000, upper_bound: 'h0000_3000},
      '{slave_index: 'h3, lower_bound: 'h0000_3000, upper_bound: 'h0000_4000},
      '{slave_index: 'h3, lower_bound: 'h0000_4000, upper_bound: 'h0000_5000},
      '{slave_index: 'h2, lower_bound: 'h0000_5000, upper_bound: 'h0000_6000},
      '{slave_index: 'h1, lower_bound: 'h0000_6000, upper_bound: 'h0000_7000},
      '{slave_index: 'h0, lower_bound: 'h0000_7000, upper_bound: 'h0000_8000},
      '{slave_index: 'h0, lower_bound: 'h0000_8000, upper_bound: 'h0000_9000}
  };

endpackage

`endif
