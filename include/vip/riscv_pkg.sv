package riscv_pkg;

  localparam int NumReg = 32;
  localparam int ImmLen = 20;

  typedef enum logic [9:0] {
    INVALID,
    ADD,
    ADDI,
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
    LH,
    LHU,
    LUI,
    LW,
    OR,
    ORI,
    SB,
    SH,
    SLL,
    SLLI,
    SLT,
    SLTI,
    SLTIU,
    SLTU,
    SRA,
    SRAI,
    SRL,
    SRLI,
    SUB,
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
