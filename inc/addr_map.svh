// ### Author : Foez Ahmed (foez.official@gmail.com))

`ifndef ADDR_MAP_SVH
`define ADDR_MAP_SVH

// Typedef addr map type
`define ADDR_MAP_T(__NAME__, __NUM_SLV__, __ADDR_WIDTH__) \
    typedef struct packed {                               \
        bit [$clog2(``__NUM_SLV__``)-1:0] slave_index;    \
        bit [   (``__ADDR_WIDTH__``)-1:0] lower_bound;    \
        bit [   (``__ADDR_WIDTH__``)-1:0] upper_bound;    \
    } ``__NAME__``;                                       \


`endif
