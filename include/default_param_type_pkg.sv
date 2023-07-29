`include "addr_map.svh"

package default_param_type_pkg;

  localparam int addr_decoder_num_slv = 15;
  localparam int addr_decoder_addr_width = 64;
  localparam int addr_decoder_num_rules = 37;
  `ADDR_MAP_T(addr_decoder_addr_map_t, addr_decoder_num_slv, addr_decoder_addr_width)

endpackage
