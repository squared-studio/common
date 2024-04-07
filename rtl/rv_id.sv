/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
//`include "default_param_pkg.sv"

module rv_id
  import riscv_pkg::*;
#(
    parameter bit RV32I = 0,
    parameter bit RV64I = 0
) (
    input  logic           [31:0] instr_i,
    output decoded_instr_t        decode_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  imm_t imm;
  logic [$clog2(ImmLen):0] imm_len;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin
    decode_o = '0;
    case (instr_i[6:0])

      'h03: begin
        imm_len = 12;
        imm = instr_i[31:20];
        decode_o.rs1 = instr_i[19:15];
        decode_o.rd = instr_i[11:7];
        case (instr_i[14:12])
          0: decode_o.func = LB;
          1: decode_o.func = LH;
          2: decode_o.func = LW;
          4: decode_o.func = LBU;
          5: decode_o.func = LHU;
          default: begin
            if (RV64I) begin
              case (instr_i[14:12])
                3: decode_o.func = LD;
                6: decode_o.func = LWU;
                default: begin
                end
              endcase
            end
          end
        endcase
      end

      default: begin
      end

    endcase
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    if (RV32I == 0) begin
      $display("\033[1;33m%m Base 32I must always be included\033[0m");
    end
  end
`endif  // SIMULATION

endmodule
