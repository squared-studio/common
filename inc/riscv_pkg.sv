
`ifndef RISCV_PKG_SV
`define RISCV_PKG_SV

package riscv_pkg;

  localparam int NumReg = 32;
  localparam int ImmLen = 20;

  typedef enum logic [9:0] {
    INVALID,
    ADD,
    ADDI,
    ADDIW,
    ADDW,
    AND,
    ANDI,
    AUIPC,
    BEQ,
    BGE,
    BGEU,
    BLT,
    BLTU,
    BNE,
    EBREAK,
    ECALL,
    FENCE,
    JAL,
    JALR,
    LB,
    LBU,
    LD,
    LH,
    LHU,
    LUI,
    LW,
    LWU,
    OR,
    ORI,
    SB,
    SD,
    SH,
    SLL,
    SLLI,
    SLLIW,
    SLLW,
    SLT,
    SLTI,
    SLTIU,
    SLTU,
    SRA,
    SRAI,
    SRAIW,
    SRAW,
    SRL,
    SRLI,
    SRLIW,
    SRLW,
    SUB,
    SUBW,
    SW,
    XOR,
    XORI
  } rv_func_t;

  typedef logic [$clog2(NumReg)-1:0] reg_index_t;

  typedef logic [ImmLen-1:0] imm_t;

  typedef struct packed {
    rv_func_t   func;
    reg_index_t rs1;
    reg_index_t rs2;
    imm_t       imm;
    reg_index_t rd;
  } decoded_instr_t;

endpackage

`endif
