package isa_pkg;

  typedef struct packed {
    bit [24:0] funct;
    bit [6:0]  opcode;
  } inst_t;

`ifdef RV32I
  parameter inst_t INST_LUI       = 'h00000037;
  parameter inst_t INST_AUIPC     = 'h00000017;
  parameter inst_t INST_JAL       = 'h0000006f;
  parameter inst_t INST_JALR      = 'h00000067;
  parameter inst_t INST_BEQ       = 'h00000063;
  parameter inst_t INST_BNE       = 'h000000e3;
  parameter inst_t INST_BLT       = 'h00000263;
  parameter inst_t INST_BGE       = 'h000002e3;
  parameter inst_t INST_BLTU      = 'h00000363;
  parameter inst_t INST_BGEU      = 'h000003e3;
  parameter inst_t INST_LB        = 'h00000003;
  parameter inst_t INST_LH        = 'h00000083;
  parameter inst_t INST_LW        = 'h00000103;
  parameter inst_t INST_LBU       = 'h00000203;
  parameter inst_t INST_LHU       = 'h00000283;
  parameter inst_t INST_SB        = 'h00000023;
  parameter inst_t INST_SH        = 'h000000a3;
  parameter inst_t INST_SW        = 'h00000123;
  parameter inst_t INST_ADDI      = 'h00000013;
  parameter inst_t INST_SLTI      = 'h00000113;
  parameter inst_t INST_SLTIU     = 'h00000193;
  parameter inst_t INST_XORI      = 'h00000213;
  parameter inst_t INST_ORI       = 'h00000313;
  parameter inst_t INST_ANDI      = 'h00000393;
  parameter inst_t INST_SLLI      = 'h00000093;
  parameter inst_t INST_SRLI      = 'h00000293;
  parameter inst_t INST_SRAI      = 'h00008293;
  parameter inst_t INST_ADD       = 'h00000033;
  parameter inst_t INST_SUB       = 'h00008033;
  parameter inst_t INST_SLL       = 'h000000b3;
  parameter inst_t INST_SLT       = 'h00000133;
  parameter inst_t INST_SLTU      = 'h000001b3;
  parameter inst_t INST_XOR       = 'h00000233;
  parameter inst_t INST_SRL       = 'h000002b3;
  parameter inst_t INST_SRA       = 'h000082b3;
  parameter inst_t INST_OR        = 'h00000333;
  parameter inst_t INST_AND       = 'h000003b3;
  parameter inst_t INST_FENCE     = 'h0000000f;
  parameter inst_t INST_ECALL     = 'h00000073;
  parameter inst_t INST_EBREAK    = 'h00100073;
`endif  // RV32I

`ifdef RV64I
  parameter inst_t INST_LWU       = 'h00000303;
  parameter inst_t INST_LD        = 'h00000183;
  parameter inst_t INST_SD        = 'h000001a3;
  parameter inst_t INST_SLLI      = 'h00000093;
  parameter inst_t INST_SRLI      = 'h00000293;
  parameter inst_t INST_SRAI      = 'h00004293;
  parameter inst_t INST_ADDIW     = 'h0000001b;
  parameter inst_t INST_SLLIW     = 'h0000009b;
  parameter inst_t INST_SRLIW     = 'h0000029b;
  parameter inst_t INST_SRAIW     = 'h0000829b;
  parameter inst_t INST_ADDW      = 'h0000003b;
  parameter inst_t INST_SUBW      = 'h0000803b;
  parameter inst_t INST_SLLW      = 'h000000bb;
  parameter inst_t INST_SRLW      = 'h000002bb;
  parameter inst_t INST_SRAW      = 'h000082bb;
`endif  // RV64I

`ifdef RV32_RV64
  parameter inst_t INST_FENCE_I   = 'h0000008f;
  parameter inst_t INST_CSRRW     = 'h000000f3;
  parameter inst_t INST_CSRRS     = 'h00000173;
  parameter inst_t INST_CSRRC     = 'h000001f3;
  parameter inst_t INST_CSRRWI    = 'h000002f3;
  parameter inst_t INST_CSRRSI    = 'h00000373;
  parameter inst_t INST_CSRRCI    = 'h000003f3;
`endif  // RV32_RV64

`ifdef RV32M
  parameter inst_t INST_MUL       = 'h00000433;
  parameter inst_t INST_MULH      = 'h000004b3;
  parameter inst_t INST_MULHSU    = 'h00000533;
  parameter inst_t INST_MULHU     = 'h000005b3;
  parameter inst_t INST_DIV       = 'h00000633;
  parameter inst_t INST_DIVU      = 'h000006b3;
  parameter inst_t INST_REM       = 'h00000733;
  parameter inst_t INST_REMU      = 'h000007b3;
`endif  // RV32M

`ifdef RV64M
  parameter inst_t INST_MULW      = 'h0000043b;
  parameter inst_t INST_DIVW      = 'h0000063b;
  parameter inst_t INST_DIVUW     = 'h000006bb;
  parameter inst_t INST_REMW      = 'h0000073b;
  parameter inst_t INST_REMUW     = 'h000007bb;
`endif  // RV64M

`ifdef RV32A
  parameter inst_t INST_LR_W      = 'h0001012f;
  parameter inst_t INST_SC_W      = 'h00000d2f;
  parameter inst_t INST_AMOSWAP_W = 'h0000052f;
  parameter inst_t INST_AMOADD_W  = 'h0000012f;
  parameter inst_t INST_AMOXOR_W  = 'h0000112f;
  parameter inst_t INST_AMOAND_W  = 'h0000312f;
  parameter inst_t INST_AMOOR_W   = 'h0000212f;
  parameter inst_t INST_AMOMIN_W  = 'h0000412f;
  parameter inst_t INST_AMOMAX_W  = 'h0000512f;
  parameter inst_t INST_AMOMINU_W = 'h0000612f;
  parameter inst_t INST_AMOMAXU_W = 'h0000712f;
`endif  // RV32A

`ifdef RV64A
  parameter inst_t INST_LR_D      = 'h000101af;
  parameter inst_t INST_SC_D      = 'h00000daf;
  parameter inst_t INST_AMOSWAP_D = 'h000005af;
  parameter inst_t INST_AMOADD_D  = 'h000001af;
  parameter inst_t INST_AMOXOR_D  = 'h000011af;
  parameter inst_t INST_AMOAND_D  = 'h000031af;
  parameter inst_t INST_AMOOR_D   = 'h000021af;
  parameter inst_t INST_AMOMIN_D  = 'h000041af;
  parameter inst_t INST_AMOMAX_D  = 'h000051af;
  parameter inst_t INST_AMOMINU_D = 'h000061af;
  parameter inst_t INST_AMOMAXU_D = 'h000071af;
`endif  // RV64A

`ifdef RV32F
  parameter inst_t INST_FLW       = 'h00000107;
  parameter inst_t INST_FSW       = 'h00000127;
  parameter inst_t INST_FMADD_S   = 'h00000043;
  parameter inst_t INST_FMSUB_S   = 'h00000047;
  parameter inst_t INST_FNMSUB_S  = 'h0000004b;
  parameter inst_t INST_FNMADD_S  = 'h0000004f;
  parameter inst_t INST_FADD_S    = 'h00000053;
  parameter inst_t INST_FSUB_S    = 'h00000253;
  parameter inst_t INST_FMUL_S    = 'h00000453;
  parameter inst_t INST_FDIV_S    = 'h00000653;
  parameter inst_t INST_FSQRT_S   = 'h0002c053;
  parameter inst_t INST_FSGNJ_S   = 'h00004053;
  parameter inst_t INST_FSGNJN_S  = 'h000040d3;
  parameter inst_t INST_FSGNJX_S  = 'h00004153;
  parameter inst_t INST_FMIN_S    = 'h00005053;
  parameter inst_t INST_FMAX_S    = 'h000050d3;
  parameter inst_t INST_FCVT_W_S  = 'h00060053;
  parameter inst_t INST_FCVT_WU_S = 'h000600d3;
  parameter inst_t INST_FMV_X_W   = 'h00380053;
  parameter inst_t INST_FEQ_S     = 'h00014153;
  parameter inst_t INST_FLT_S     = 'h000140d3;
  parameter inst_t INST_FLE_S     = 'h00014053;
  parameter inst_t INST_FCLASS_S  = 'h003800d3;
  parameter inst_t INST_FCVT_S_W  = 'h00068053;
  parameter inst_t INST_FCVT_S_WU = 'h000680d3;
  parameter inst_t INST_FMV_W_X   = 'h003c0053;
`endif  // RV32F

`ifdef RV64F
  parameter inst_t INST_FCVT_L_S  = 'h00060153;
  parameter inst_t INST_FCVT_LU_S = 'h000601d3;
  parameter inst_t INST_FCVT_S_L  = 'h00068153;
  parameter inst_t INST_FCVT_S_LU = 'h000681d3;
`endif  // RV64F

`ifdef RV32D
  parameter inst_t INST_FLD       = 'h00000187;
  parameter inst_t INST_FSD       = 'h000001a7;
  parameter inst_t INST_FMADD_D   = 'h000000c3;
  parameter inst_t INST_FMSUB_D   = 'h000000c7;
  parameter inst_t INST_FNMSUB_D  = 'h000000cb;
  parameter inst_t INST_FNMADD_D  = 'h000000cf;
  parameter inst_t INST_FADD_D    = 'h000000d3;
  parameter inst_t INST_FSUB_D    = 'h000002d3;
  parameter inst_t INST_FMUL_D    = 'h000004d3;
  parameter inst_t INST_FDIV_D    = 'h000006d3;
  parameter inst_t INST_FSQRT_D   = 'h0002d053;
  parameter inst_t INST_FSGNJ_D   = 'h00004453;
  parameter inst_t INST_FSGNJN_D  = 'h000044d3;
  parameter inst_t INST_FSGNJX_D  = 'h00004553;
  parameter inst_t INST_FMIN_D    = 'h00005453;
  parameter inst_t INST_FMAX_D    = 'h000054d3;
  parameter inst_t INST_FCVT_S_D  = 'h000200d3;
  parameter inst_t INST_FCVT_D_S  = 'h00021053;
  parameter inst_t INST_FEQ_D     = 'h00014553;
  parameter inst_t INST_FLT_D     = 'h000144d3;
  parameter inst_t INST_FLE_D     = 'h00014453;
  parameter inst_t INST_FCLASS_D  = 'h003880d3;
  parameter inst_t INST_FCVT_W_D  = 'h00061053;
  parameter inst_t INST_FCVT_WU_D = 'h000610d3;
  parameter inst_t INST_FCVT_D_W  = 'h00069053;
  parameter inst_t INST_FCVT_D_WU = 'h000690d3;
`endif  // RV32D

`ifdef RV64D
  parameter inst_t INST_FCVT_L_D  = 'h00061153;
  parameter inst_t INST_FCVT_LU_D = 'h000611d3;
  parameter inst_t INST_FMV_X_D   = 'h00388053;
  parameter inst_t INST_FCVT_D_L  = 'h00069153;
  parameter inst_t INST_FCVT_D_LU = 'h000691d3;
  parameter inst_t INST_FMV_D_X   = 'h003c8053;
`endif  // RV64D

`ifdef RV32Q
  parameter inst_t INST_FLQ       = 'h00000207;
  parameter inst_t INST_FSQ       = 'h00000227;
  parameter inst_t INST_FMADD_Q   = 'h000001c3;
  parameter inst_t INST_FMSUB_Q   = 'h000001c7;
  parameter inst_t INST_FNMSUB_Q  = 'h000001cb;
  parameter inst_t INST_FNMADD_Q  = 'h000001cf;
  parameter inst_t INST_FADD_Q    = 'h000001d3;
  parameter inst_t INST_FSUB_Q    = 'h000003d3;
  parameter inst_t INST_FMUL_Q    = 'h000005d3;
  parameter inst_t INST_FDIV_Q    = 'h000007d3;
  parameter inst_t INST_FSQRT_Q   = 'h0002f053;
  parameter inst_t INST_FSGNJ_Q   = 'h00004c53;
  parameter inst_t INST_FSGNJN_Q  = 'h00004cd3;
  parameter inst_t INST_FSGNJX_Q  = 'h00004d53;
  parameter inst_t INST_FMIN_Q    = 'h00005c53;
  parameter inst_t INST_FMAX_Q    = 'h00005cd3;
  parameter inst_t INST_FCVT_S_Q  = 'h000201d3;
  parameter inst_t INST_FCVT_Q_S  = 'h00023053;
  parameter inst_t INST_FCVT_D_Q  = 'h000211d3;
  parameter inst_t INST_FCVT_Q_D  = 'h000230d3;
  parameter inst_t INST_FEQ_Q     = 'h00014d53;
  parameter inst_t INST_FLT_Q     = 'h00014cd3;
  parameter inst_t INST_FLE_Q     = 'h00014c53;
  parameter inst_t INST_FCLASS_Q  = 'h003980d3;
  parameter inst_t INST_FCVT_W_Q  = 'h00063053;
  parameter inst_t INST_FCVT_WU_Q = 'h000630d3;
  parameter inst_t INST_FCVT_Q_W  = 'h0006b053;
  parameter inst_t INST_FCVT_Q_WU = 'h0006b0d3;
`endif  // RV32Q

`ifdef RV64Q
  parameter inst_t INST_FCVT_L_Q  = 'h00063153;
  parameter inst_t INST_FCVT_LU_Q = 'h000631d3;
  parameter inst_t INST_FCVT_Q_L  = 'h0006b153;
  parameter inst_t INST_FCVT_Q_LU = 'h0006b1d3;
`endif  // RV64Q


endpackage

