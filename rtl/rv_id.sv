/*
Write a markdown documentation for this systemverilog module:
Author : Foez Ahmed (foez.official@gmail.com)
*/

`include "riscv_pkg.sv"

module rv_id
  import riscv_pkg::*;
#(
    parameter bit RV32I = 1,
    parameter bit RV64I = 1,
    parameter bit RVF   = 1,
    parameter bit RVD   = 1,
    parameter bit RVQ   = 1
) (
    input  logic          [31:0] inst_i,
    output decoded_inst_t        inst_o
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
    inst_o.imm = imm;
    case (imm_len)
      default: for (int i = ImmLen; i < ImmLen; i++) inst_o.imm[i] = inst_o.imm[i-1];
      12: for (int i = 12; i < ImmLen; i++) inst_o.imm[i] = inst_o.imm[i-1];
      13: for (int i = 13; i < ImmLen; i++) inst_o.imm[i] = inst_o.imm[i-1];
      20: for (int i = 20; i < ImmLen; i++) inst_o.imm[i] = inst_o.imm[i-1];
    endcase
  end

  always_comb begin
    inst_o = '0;
    case (inst_i[6:0])

      default: begin
      end

      'h03: begin : LOAD
        imm_len    = 12;
        imm        = inst_i[31:20];
        inst_o.rs1 = inst_i[19:15];
        inst_o.rd  = inst_i[11:7];
        case (inst_i[14:12])
          0: if (RV32I) inst_o.func = LB;
          1: if (RV32I) inst_o.func = LH;
          2: if (RV32I) inst_o.func = LW;
          3: if (RV64I) inst_o.func = LD;
          4: if (RV32I) inst_o.func = LBU;
          5: if (RV32I) inst_o.func = LHU;
          6: if (RV64I) inst_o.func = LWU;
          default: begin
          end
        endcase
      end

      'h07: begin : LOAD_FP
        imm_len    = 12;
        imm        = inst_i[31:20];
        inst_o.rs1 = inst_i[19:15];
        inst_o.rd  = inst_i[11:7];
        case (inst_i[14:12])
          2: if (RVF) inst_o.func = FLW;
          3: if (RVD) inst_o.func = FLD;
          4: if (RVQ) inst_o.func = FLQ;
          default: begin
          end
        endcase
      end

      'h0F: begin : MISC_MEM
        inst_o.fm   = inst_i[31:28];
        inst_o.pred = inst_i[27:24];
        inst_o.succ = inst_i[23:20];
        inst_o.rs1  = inst_i[19:15];
        inst_o.rd   = inst_i[11:7];
        case (inst_i[14:12])
          0: if (RV32I) inst_o.func = FENCE;
          default: begin
          end
        endcase
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
