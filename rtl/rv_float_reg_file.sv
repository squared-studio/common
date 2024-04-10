/*
Write a markdown documentation for this systemverilog module:

| Precision              | Sign Bit | Exponent Bits | mantissa Bits | Bias  | Format |
|------------------------|----------|---------------|---------------|-------|--------|
| 16b (Half Precision)   | 1 (15)   | 5 [14:10]     | 10 [9:0]      | 15    | 10     |
| 32b (Single Precision) | 1 (31)   | 8 [30:23]     | 23 [22:0]     | 127   | 00     |
| 64b (Double Precision) | 1 (63)   | 11 [62:52]    | 52 [51:0]     | 1023  | 01     |
| 128b (Quad Precision)  | 1 (127)  | 15 [126:112]  | 112 [111:0]   | 16383 | 11     |

// ### Author : Foez Ahmed (foez.official@gmail.com)
*/

module rv_float_reg_file #(
    parameter bit DOUBLE = 0,
    parameter bit QUAD = 1,
    localparam int RegWidth = QUAD ? 128 : (DOUBLE ? 64 : 32),
    localparam int NumReg = 32,
    localparam int NumRS = 3,
    localparam int AddrWidth = $clog2(NumReg)
) (
    input logic clk_i,
    input logic arst_ni,

    input  logic [AddrWidth-1:0] rs1_addr_i,
    input  logic [          1:0] rs1_fmt_i,
    output logic [ RegWidth-1:0] rs1_data_o,

    input  logic [AddrWidth-1:0] rs2_addr_i,
    input  logic [          1:0] rs2_fmt_i,
    output logic [ RegWidth-1:0] rs2_data_o,

    input  logic [AddrWidth-1:0] rs3_addr_i,
    input  logic [          1:0] rs3_fmt_i,
    output logic [ RegWidth-1:0] rs3_data_o,

    input logic [AddrWidth-1:0] rd_addr_i,
    input logic [          1:0] rd_fmt_i,
    input logic [ RegWidth-1:0] rd_data_i,
    input logic                 rd_en_i
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef struct packed {
    logic sign;
    logic [4:0] exponent;
    logic [9:0] mantissa;
  } float16_t;

  typedef struct packed {
    logic sign;
    logic [7:0] exponent;
    logic [22:0] mantissa;
  } float32_t;

  typedef struct packed {
    logic sign;
    logic [10:0] exponent;
    logic [51:0] mantissa;
  } float64_t;

  typedef struct packed {
    logic sign;
    logic [14:0] exponent;
    logic [111:0] mantissa;
  } float128_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic [NumRS-1:0][AddrWidth-1:0] rs_addr;
  logic [NumRS-1:0][RegWidth-1:0] rs_data;
  logic [RegWidth-1:0] rd_data;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign rs_addr[0] = rs1_addr_i;
  assign rs_addr[1] = rs2_addr_i;
  assign rs_addr[2] = rs3_addr_i;

  `define RS_CONV(__NUM__)                                                                         \
    if (QUAD) begin : g_max_quad``__NUM__``                                                        \
                                                                                                   \
      always_comb begin                                                                            \
        float16_t data16;                                                                          \
        float32_t data32;                                                                          \
        float64_t data64;                                                                          \
        float128_t data128;                                                                        \
                                                                                                   \
        int exp;                                                                                   \
                                                                                                   \
        data128 = rs_data[``__NUM__``-1];                                                          \
                                                                                                   \
        data64.sign = data128.sign;                                                                \
        exp = data128.exp;                                                                         \
        exp = exp - 16383 + 1023;                                                                  \
        if ((exp > 2047) || (exp < 0)) begin                                                       \
          data64.exp = '1;                                                                         \
          data64.mantissa = '0;                                                                    \
        end else begin                                                                             \
          data64.exp = exp;                                                                        \
          foreach (data64.mantissa[i]) data64.mantissa[i] = data128.mantissa[i+60];                \
        end                                                                                        \
                                                                                                   \
        data32.sign = data128.sign;                                                                \
        exp = data128.exp;                                                                         \
        exp = exp - 16383 + 127;                                                                   \
        if ((exp > 255) || (exp < 0)) begin                                                        \
          data32.exp = '1;                                                                         \
          data32.mantissa = '0;                                                                    \
        end else begin                                                                             \
          data32.exp = exp;                                                                        \
          foreach (data32.mantissa[i]) data32.mantissa[i] = data128.mantissa[i+89];                \
        end                                                                                        \
                                                                                                   \
        data16.sign = data128.sign;                                                                \
        exp = data128.exp;                                                                         \
        exp = exp - 16383 + 15;                                                                    \
        if ((exp > 31) || (exp < 0)) begin                                                         \
          data16.exp = '1;                                                                         \
          data16.mantissa = '0;                                                                    \
        end else begin                                                                             \
          data16.exp = exp;                                                                        \
          foreach (data16.mantissa[i]) data16.mantissa[i] = data128.mantissa[i+102];               \
        end                                                                                        \
                                                                                                   \
        case (rs``__NUM__``_fmt_i)                                                                 \
          2'b00:   rs``__NUM__``_data_o = data32;                                                  \
          2'b01:   rs``__NUM__``_data_o = data64;                                                  \
          2'b10:   rs``__NUM__``_data_o = data16;                                                  \
          default: rs``__NUM__``_data_o = data128;                                                 \
        endcase                                                                                    \
      end                                                                                          \
                                                                                                   \
    end else if (DOUBLE) begin : g_max_double``__NUM__``                                           \
                                                                                                   \
      always_comb begin                                                                            \
        float16_t data16;                                                                          \
        float32_t data32;                                                                          \
        float64_t data64;                                                                          \
                                                                                                   \
        int exp;                                                                                   \
                                                                                                   \
        data64 = rs_data[``__NUM__``-1];                                                           \
                                                                                                   \
        data32.sign = data64.sign;                                                                 \
        exp = data64.exp;                                                                          \
        exp = exp - 1023 + 127;                                                                    \
        if ((exp > 255) || (exp < 0)) begin                                                        \
          data32.exp = '1;                                                                         \
          data32.mantissa = '0;                                                                    \
        end else begin                                                                             \
          data32.exp = exp;                                                                        \
          foreach (data32.mantissa[i]) data32.mantissa[i] = data64.mantissa[i+29];                 \
        end                                                                                        \
                                                                                                   \
        data16.sign = data64.sign;                                                                 \
        exp = data64.exp;                                                                          \
        exp = exp - 1023 + 15;                                                                     \
        if ((exp > 31) || (exp < 0)) begin                                                         \
          data16.exp = '1;                                                                         \
          data16.mantissa = '0;                                                                    \
        end else begin                                                                             \
          data16.exp = exp;                                                                        \
          foreach (data16.mantissa[i]) data16.mantissa[i] = data64.mantissa[i+42];                 \
        end                                                                                        \
                                                                                                   \
        case (rs``__NUM__``_fmt_i)                                                                 \
          2'b00:   rs``__NUM__``_data_o = data32;                                                  \
          2'b10:   rs``__NUM__``_data_o = data16;                                                  \
          default: rs``__NUM__``_data_o = data64;                                                  \
        endcase                                                                                    \
      end                                                                                          \
                                                                                                   \
    end else begin : g_max_float``__NUM__``                                                        \
                                                                                                   \
      always_comb begin                                                                            \
        float16_t data16;                                                                          \
        float32_t data32;                                                                          \
                                                                                                   \
        int exp;                                                                                   \
                                                                                                   \
        data32 = rs_data[``__NUM__``-1];                                                           \
                                                                                                   \
        data16.sign = data32.sign;                                                                 \
        exp = data32.exp;                                                                          \
        exp = exp - 127 + 15;                                                                      \
        if ((exp > 31) || (exp < 0)) begin                                                         \
          data16.exp = '1;                                                                         \
          data16.mantissa = '0;                                                                    \
        end else begin                                                                             \
          data16.exp = exp;                                                                        \
          foreach (data16.mantissa[i]) data16.mantissa[i] = data32.mantissa[i+13];                 \
        end                                                                                        \
                                                                                                   \
        case (rs``__NUM__``_fmt_i)                                                                 \
          2'b10:   rs``__NUM__``_data_o = data16;                                                  \
          default: rs``__NUM__``_data_o = data32;                                                  \
        endcase                                                                                    \
      end                                                                                          \
                                                                                                   \
    end                                                                                            \


  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  reg_file #(
      .NUM_RS   (NumRS),
      .ZERO_REG (0),
      .NUM_REG  (NumReg),
      .REG_WIDTH(RegWidth)
  ) u_reg_file (
      .clk_i,
      .arst_ni,

      .rd_addr_i,
      .rd_data_i(rd_data),
      .rd_en_i,

      .rs_addr_i(rs_addr),
      .rs_data_o(rs_data)
  );

endmodule
