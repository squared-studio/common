/*
Write a markdown documentation for this systemverilog module:

| Precision              | Sign Bit | Exponent Bits | mantissa Bits | Bias  | Format |
|------------------------|----------|---------------|---------------|-------|--------|
| 16b (Half Precision)   | 1 (15)   | 5 [14:10]     | 10 [9:0]      | 15    | 10     |
| 32b (Single Precision) | 1 (31)   | 8 [30:23]     | 23 [22:0]     | 127   | 00     |
| 64b (Double Precision) | 1 (63)   | 11 [62:52]    | 52 [51:0]     | 1023  | 01     |
| 128b (Quad Precision)  | 1 (127)  | 15 [126:112]  | 112 [111:0]   | 16383 | 11     |

// ### Author : Foez Ahmed (foez.official@gmail.com)
0100000
*/

module rv_float_converter
// import riscv_pkg::float16_t;
// import riscv_pkg::float32_t;
// import riscv_pkg::float64_t;
// import riscv_pkg::float128_t;
#(
    parameter  bit UP_CONV     = 1,
    parameter  bit DOWN_CONV   = 0,
    parameter  bit DOUBLE      = 1,
    parameter  bit QUAD        = 1,
    localparam int MaxRegWidth = QUAD ? 128 : (DOUBLE ? 64 : 32)
) (
    input  logic [MaxRegWidth-1:0] data_i,
    input  logic [            1:0] ip_fmt_i,
    input  logic [            1:0] op_fmt_i,
    output logic [MaxRegWidth-1:0] data_o
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

  logic [          127:0] masked_data_i;  // masked version of the input data
  logic                   is_non_zero;  // signifies whether data_i is zero
  logic                   is_nan_infinite;  // signifies whether data_i is NaN or infinite
  logic [MaxRegWidth-1:0] up_data;  // data after up conversion
  logic [MaxRegWidth-1:0] round_data;  // data after rounding
  logic [MaxRegWidth-1:0] down_data;  // data after down conversion

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////
  // Generate masked data
  ////////////////////////////////////////////////

  always_comb begin
    masked_data_i = '0;
    case (ip_fmt_i)
      2'b00:   masked_data_i = data_i & 'hFFFF_FFFF;
      2'b01:   masked_data_i = data_i & 'hFFFF_FFFF_FFFF_FFFF;
      2'b10:   masked_data_i = data_i & 'hFFFF;
      default: masked_data_i = data_i & 'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
    endcase
  end

  ////////////////////////////////////////////////
  // is zero?
  ////////////////////////////////////////////////

  always_comb begin
    is_non_zero = 0;
    for (int i = 0; i < 15; i++) is_non_zero |= masked_data_i[i];
    if (ip_fmt_i != 2) begin
      for (int i = 15; i < 31; i++) is_non_zero |= masked_data_i[i];
      if (ip_fmt_i != 0) begin
        for (int i = 31; i < 63; i++) is_non_zero |= masked_data_i[i];
        if (ip_fmt_i != 1) begin
          for (int i = 63; i < 127; i++) is_non_zero |= masked_data_i[i];
        end
      end
    end
  end

  ////////////////////////////////////////////////
  // is infinite/nan?
  ////////////////////////////////////////////////

  always_comb begin
    is_nan_infinite = '0;
    case (ip_fmt_i)
      2'b00: begin
        if (masked_data_i[30:23] == '1) begin
          is_nan_infinite = 1;
        end
      end
      2'b01: begin
        if (masked_data_i[62:52] == '1) begin
          is_nan_infinite = 1;
        end
      end
      2'b10: begin
        if (masked_data_i[14:10] == '1) begin
          is_nan_infinite = 1;
        end
      end
      default: begin
        if (masked_data_i[126:112] == '1) begin
          is_nan_infinite = 1;
        end
      end
    endcase
  end

  ////////////////////////////////////////////////
  // UP_CONV
  ////////////////////////////////////////////////

  `define UP_CONV(__SRC__, __SRC_BIAS__, __DST_BIAS__, __SRC_MANTS__, __DST_MANTS__) \
    begin                                                                            \
      float``__SRC__``_t src;                                                        \
      src = masked_data_i;                                                           \
      dst.sign = src.sign;                                                           \
      if (is_nan_infinite) dst.exponent = '1;                                        \
      else dst.exponent = src.exponent + ``__DST_BIAS__`` - ``__SRC_BIAS__``;        \
      dst.mantissa = '0;                                                             \
      for (int i = 0; i < ``__SRC_MANTS__``; i++) begin                              \
        dst.mantissa[i+ ``__DST_MANTS__`` - ``__SRC_MANTS__`` ] = src.mantissa[i];   \
      end                                                                            \
    end                                                                              \


  if (UP_CONV) begin : g_up_conv

    if (QUAD) begin : g_max_quad
      always_comb begin
        float128_t dst;
        case (ip_fmt_i)
          2'b00:   `UP_CONV(32, 127, 16383, 23, 112)
          2'b01:   `UP_CONV(64, 1023, 16383, 52, 112)
          2'b10:   `UP_CONV(16, 15, 16383, 10, 112)
          default: dst = masked_data_i;
        endcase
        up_data = dst;
      end
    end else if (DOUBLE) begin : g_max_double
      always_comb begin
        float64_t dst;
        case (ip_fmt_i)
          2'b00:   `UP_CONV(32, 127, 1023, 23, 52)
          2'b10:   `UP_CONV(16, 15, 1023, 10, 52)
          default: dst = masked_data_i;
        endcase
        up_data = dst;
      end
    end else begin : g_max_single
      always_comb begin
        float32_t dst;
        case (ip_fmt_i)
          2'b10:   `UP_CONV(16, 15, 127, 10, 23)
          default: dst = masked_data_i;
        endcase
        up_data = dst;
      end
    end

  end else begin : g_no_up_conv
    assign up_data = masked_data_i;
  end

  ////////////////////////////////////////////////
  // ROUND
  ////////////////////////////////////////////////

  assign round_data = up_data;

  ////////////////////////////////////////////////
  // DOWN_CONV
  ////////////////////////////////////////////////

  if (DOWN_CONV) begin : g_down_conv

  end else begin : g_no_down_conv
    assign down_data = round_data;
  end

  ////////////////////////////////////////////////
  // FINAL
  ////////////////////////////////////////////////

  always_comb begin
    if (~is_non_zero) begin
      data_o = '0;
    end else begin
      data_o = down_data;
    end
  end

endmodule
