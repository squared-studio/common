/*
Author : Foez Ahmed (foez.official@gmail.com)
This file is part of squared-studio:common
Copyright (c) 2024 squared-studio
Licensed under the MIT License
See LICENSE file in the project root for full license information
*/

`ifndef ADDR_MAP_SVH
`define ADDR_MAP_SVH

// Typedef addr map type
`define ADDR_MAP_T(__NAME__, __INDEX_WIDTH__, __ADDR_WIDTH__)   \
    typedef struct packed {                                     \
        bit [``__INDEX_WIDTH__``-1:0] slave_index;              \
        bit [ ``__ADDR_WIDTH__``-1:0] lower_bound;              \
        bit [ ``__ADDR_WIDTH__``-1:0] upper_bound;              \
    } ``__NAME__``;                                             \


`endif
