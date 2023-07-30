`include "addr_map.svh"

package default_param_type_pkg;

  parameter int ADDR_DECODER_NUM_SLV = 15;
  parameter int ADDR_DECODER_ADDR_WIDTH = 64;
  parameter int ADDR_DECODER_NUM_RULES = 37;
  `ADDR_MAP_T(addr_decoder_addr_map_t, ADDR_DECODER_NUM_SLV, ADDR_DECODER_ADDR_WIDTH)

endpackage
