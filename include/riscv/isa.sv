// ### Author : Foez Ahmed (foez.official@gmail.com)

`ifdef RV64I
  `ifndef RV32I
    `define RV32I
  `endif // RV32I
`endif // RV64I

`ifdef RV64M
  `ifndef RV32M
    `define RV32M
  `endif // RV32M
`endif // RV64M

`ifdef RV64A
  `ifndef RV32A
    `define RV32A
  `endif // RV32A
`endif // RV64A

`ifdef RV64F
  `ifndef RV32F
    `define RV32F
  `endif // RV32F
`endif // RV64F

`ifdef RV64D
  `ifndef RV32D
    `define RV32D
  `endif // RV32D
`endif // RV64D

`ifdef RV64Q
  `ifndef RV32Q
    `define RV32Q
  `endif // RV32Q
`endif // RV64Q

  typedef struct packed {
    bit [24:0] funct;
    bit [6:0]  opcode;
  } inst_t;

  const longint unsigned   x0 =   0;
  const longint unsigned   x1 =   1;
  const longint unsigned   x2 =   2;
  const longint unsigned   x3 =   3;
  const longint unsigned   x4 =   4;
  const longint unsigned   x5 =   5;
  const longint unsigned   x6 =   6;
  const longint unsigned   x7 =   7;
  const longint unsigned   x8 =   8;
  const longint unsigned   x9 =   9;
  const longint unsigned  x10 =  10;
  const longint unsigned  x11 =  11;
  const longint unsigned  x12 =  12;
  const longint unsigned  x13 =  13;
  const longint unsigned  x14 =  14;
  const longint unsigned  x15 =  15;
  const longint unsigned  x16 =  16;
  const longint unsigned  x17 =  17;
  const longint unsigned  x18 =  18;
  const longint unsigned  x19 =  19;
  const longint unsigned  x20 =  20;
  const longint unsigned  x21 =  21;
  const longint unsigned  x22 =  22;
  const longint unsigned  x23 =  23;
  const longint unsigned  x24 =  24;
  const longint unsigned  x25 =  25;
  const longint unsigned  x26 =  26;
  const longint unsigned  x27 =  27;
  const longint unsigned  x28 =  28;
  const longint unsigned  x29 =  29;
  const longint unsigned  x30 =  30;
  const longint unsigned  x31 =  31;

  const longint unsigned zero =  x0;
  const longint unsigned   ra =  x1;
  const longint unsigned   sp =  x2;
  const longint unsigned   gp =  x3;
  const longint unsigned   tp =  x4;
  const longint unsigned   t0 =  x5;
  const longint unsigned   t1 =  x6;
  const longint unsigned   t2 =  x7;
  const longint unsigned   s0 =  x8;
  const longint unsigned   fp =  x8;
  const longint unsigned   s1 =  x9;
  const longint unsigned   a0 = x10;
  const longint unsigned   a1 = x11;
  const longint unsigned   a2 = x12;
  const longint unsigned   a3 = x13;
  const longint unsigned   a4 = x14;
  const longint unsigned   a5 = x15;
  const longint unsigned   a6 = x16;
  const longint unsigned   a7 = x17;
  const longint unsigned   s2 = x18;
  const longint unsigned   s3 = x19;
  const longint unsigned   s4 = x20;
  const longint unsigned   s5 = x21;
  const longint unsigned   s6 = x22;
  const longint unsigned   s7 = x23;
  const longint unsigned   s8 = x24;
  const longint unsigned   s9 = x25;
  const longint unsigned  s10 = x26;
  const longint unsigned  s11 = x27;
  const longint unsigned   t3 = x28;
  const longint unsigned   t4 = x29;
  const longint unsigned   t5 = x30;
  const longint unsigned   t6 = x31;

  const longint unsigned   f0 =   0;
  const longint unsigned   f1 =   1;
  const longint unsigned   f2 =   2;
  const longint unsigned   f3 =   3;
  const longint unsigned   f4 =   4;
  const longint unsigned   f5 =   5;
  const longint unsigned   f6 =   6;
  const longint unsigned   f7 =   7;
  const longint unsigned   f8 =   8;
  const longint unsigned   f9 =   9;
  const longint unsigned  f10 =  10;
  const longint unsigned  f11 =  11;
  const longint unsigned  f12 =  12;
  const longint unsigned  f13 =  13;
  const longint unsigned  f14 =  14;
  const longint unsigned  f15 =  15;
  const longint unsigned  f16 =  16;
  const longint unsigned  f17 =  17;
  const longint unsigned  f18 =  18;
  const longint unsigned  f19 =  19;
  const longint unsigned  f20 =  20;
  const longint unsigned  f21 =  21;
  const longint unsigned  f22 =  22;
  const longint unsigned  f23 =  23;
  const longint unsigned  f24 =  24;
  const longint unsigned  f25 =  25;
  const longint unsigned  f26 =  26;
  const longint unsigned  f27 =  27;
  const longint unsigned  f28 =  28;
  const longint unsigned  f29 =  29;
  const longint unsigned  f30 =  30;
  const longint unsigned  f31 =  31;

  const longint unsigned  ft0 =  f0;
  const longint unsigned  ft1 =  f1;
  const longint unsigned  ft2 =  f2;
  const longint unsigned  ft3 =  f3;
  const longint unsigned  ft4 =  f4;
  const longint unsigned  ft5 =  f5;
  const longint unsigned  ft6 =  f6;
  const longint unsigned  ft7 =  f7;
  const longint unsigned  fs0 =  f8;
  const longint unsigned  fs1 =  f9;
  const longint unsigned  fa0 = f10;
  const longint unsigned  fa1 = f11;
  const longint unsigned  fa2 = f12;
  const longint unsigned  fa3 = f13;
  const longint unsigned  fa4 = f14;
  const longint unsigned  fa5 = f15;
  const longint unsigned  fa6 = f16;
  const longint unsigned  fa7 = f17;
  const longint unsigned  fs2 = f18;
  const longint unsigned  fs3 = f19;
  const longint unsigned  fs4 = f20;
  const longint unsigned  fs5 = f21;
  const longint unsigned  fs6 = f22;
  const longint unsigned  fs7 = f23;
  const longint unsigned  fs8 = f24;
  const longint unsigned  fs9 = f25;
  const longint unsigned fs10 = f26;
  const longint unsigned fs11 = f27;
  const longint unsigned  ft8 = f28;
  const longint unsigned  ft9 = f29;
  const longint unsigned ft10 = f30;
  const longint unsigned ft11 = f31;

`ifdef RV32I
  const inst_t INST_LUI       = 'h00000037;
  const inst_t INST_AUIPC     = 'h00000017;
  const inst_t INST_JAL       = 'h0000006f;
  const inst_t INST_JALR      = 'h00000067;
  const inst_t INST_BEQ       = 'h00000063;
  const inst_t INST_BNE       = 'h000000e3;
  const inst_t INST_BLT       = 'h00000263;
  const inst_t INST_BGE       = 'h000002e3;
  const inst_t INST_BLTU      = 'h00000363;
  const inst_t INST_BGEU      = 'h000003e3;
  const inst_t INST_LB        = 'h00000003;
  const inst_t INST_LH        = 'h00000083;
  const inst_t INST_LW        = 'h00000103;
  const inst_t INST_LBU       = 'h00000203;
  const inst_t INST_LHU       = 'h00000283;
  const inst_t INST_SB        = 'h00000023;
  const inst_t INST_SH        = 'h000000a3;
  const inst_t INST_SW        = 'h00000123;
  const inst_t INST_ADDI      = 'h00000013;
  const inst_t INST_SLTI      = 'h00000113;
  const inst_t INST_SLTIU     = 'h00000193;
  const inst_t INST_XORI      = 'h00000213;
  const inst_t INST_ORI       = 'h00000313;
  const inst_t INST_ANDI      = 'h00000393;
  `ifndef RV64I
  const inst_t INST_SLLI      = 'h00000093;
  const inst_t INST_SRLI      = 'h00000293;
  const inst_t INST_SRAI      = 'h00008293;
  `endif //RV64I
  const inst_t INST_ADD       = 'h00000033;
  const inst_t INST_SUB       = 'h00008033;
  const inst_t INST_SLL       = 'h000000b3;
  const inst_t INST_SLT       = 'h00000133;
  const inst_t INST_SLTU      = 'h000001b3;
  const inst_t INST_XOR       = 'h00000233;
  const inst_t INST_SRL       = 'h000002b3;
  const inst_t INST_SRA       = 'h000082b3;
  const inst_t INST_OR        = 'h00000333;
  const inst_t INST_AND       = 'h000003b3;
  const inst_t INST_FENCE     = 'h0000000f;
  const inst_t INST_ECALL     = 'h00000073;
  const inst_t INST_EBREAK    = 'h00100073;
`endif  // RV32I

`ifdef RV64I
  const inst_t INST_LWU       = 'h00000303;
  const inst_t INST_LD        = 'h00000183;
  const inst_t INST_SD        = 'h000001a3;
  const inst_t INST_SLLI      = 'h00000093;
  const inst_t INST_SRLI      = 'h00000293;
  const inst_t INST_SRAI      = 'h00004293;
  const inst_t INST_ADDIW     = 'h0000001b;
  const inst_t INST_SLLIW     = 'h0000009b;
  const inst_t INST_SRLIW     = 'h0000029b;
  const inst_t INST_SRAIW     = 'h0000829b;
  const inst_t INST_ADDW      = 'h0000003b;
  const inst_t INST_SUBW      = 'h0000803b;
  const inst_t INST_SLLW      = 'h000000bb;
  const inst_t INST_SRLW      = 'h000002bb;
  const inst_t INST_SRAW      = 'h000082bb;
`endif  // RV64I

// TODO `ifdef RV32_RV64
// TODO   const inst_t INST_FENCE_I   = 'h0000008f;
// TODO   const inst_t INST_CSRRW     = 'h000000f3;
// TODO   const inst_t INST_CSRRS     = 'h00000173;
// TODO   const inst_t INST_CSRRC     = 'h000001f3;
// TODO   const inst_t INST_CSRRWI    = 'h000002f3;
// TODO   const inst_t INST_CSRRSI    = 'h00000373;
// TODO   const inst_t INST_CSRRCI    = 'h000003f3;
// TODO `endif  // RV32_RV64

`ifdef RV32M
  const inst_t INST_MUL       = 'h00000433;
  const inst_t INST_MULH      = 'h000004b3;
  const inst_t INST_MULHSU    = 'h00000533;
  const inst_t INST_MULHU     = 'h000005b3;
  const inst_t INST_DIV       = 'h00000633;
  const inst_t INST_DIVU      = 'h000006b3;
  const inst_t INST_REM       = 'h00000733;
  const inst_t INST_REMU      = 'h000007b3;
`endif  // RV32M

`ifdef RV64M
  const inst_t INST_MULW      = 'h0000043b;
  const inst_t INST_DIVW      = 'h0000063b;
  const inst_t INST_DIVUW     = 'h000006bb;
  const inst_t INST_REMW      = 'h0000073b;
  const inst_t INST_REMUW     = 'h000007bb;
`endif  // RV64M

`ifdef RV32A
  const inst_t INST_LR_W      = 'h0001012f;
  const inst_t INST_SC_W      = 'h00000d2f;
  const inst_t INST_AMOSWAP_W = 'h0000052f;
  const inst_t INST_AMOADD_W  = 'h0000012f;
  const inst_t INST_AMOXOR_W  = 'h0000112f;
  const inst_t INST_AMOAND_W  = 'h0000312f;
  const inst_t INST_AMOOR_W   = 'h0000212f;
  const inst_t INST_AMOMIN_W  = 'h0000412f;
  const inst_t INST_AMOMAX_W  = 'h0000512f;
  const inst_t INST_AMOMINU_W = 'h0000612f;
  const inst_t INST_AMOMAXU_W = 'h0000712f;
`endif  // RV32A

`ifdef RV64A
  const inst_t INST_LR_D      = 'h000101af;
  const inst_t INST_SC_D      = 'h00000daf;
  const inst_t INST_AMOSWAP_D = 'h000005af;
  const inst_t INST_AMOADD_D  = 'h000001af;
  const inst_t INST_AMOXOR_D  = 'h000011af;
  const inst_t INST_AMOAND_D  = 'h000031af;
  const inst_t INST_AMOOR_D   = 'h000021af;
  const inst_t INST_AMOMIN_D  = 'h000041af;
  const inst_t INST_AMOMAX_D  = 'h000051af;
  const inst_t INST_AMOMINU_D = 'h000061af;
  const inst_t INST_AMOMAXU_D = 'h000071af;
`endif  // RV64A

`ifdef RV32F
  const inst_t INST_FLW       = 'h00000107;
  const inst_t INST_FSW       = 'h00000127;
  const inst_t INST_FMADD_S   = 'h00000043;
  const inst_t INST_FMSUB_S   = 'h00000047;
  const inst_t INST_FNMSUB_S  = 'h0000004b;
  const inst_t INST_FNMADD_S  = 'h0000004f;
  const inst_t INST_FADD_S    = 'h00000053;
  const inst_t INST_FSUB_S    = 'h00000253;
  const inst_t INST_FMUL_S    = 'h00000453;
  const inst_t INST_FDIV_S    = 'h00000653;
  const inst_t INST_FSQRT_S   = 'h0002c053;
  const inst_t INST_FSGNJ_S   = 'h00004053;
  const inst_t INST_FSGNJN_S  = 'h000040d3;
  const inst_t INST_FSGNJX_S  = 'h00004153;
  const inst_t INST_FMIN_S    = 'h00005053;
  const inst_t INST_FMAX_S    = 'h000050d3;
  const inst_t INST_FCVT_W_S  = 'h00060053;
  const inst_t INST_FCVT_WU_S = 'h000600d3;
  const inst_t INST_FMV_X_W   = 'h00380053;
  const inst_t INST_FEQ_S     = 'h00014153;
  const inst_t INST_FLT_S     = 'h000140d3;
  const inst_t INST_FLE_S     = 'h00014053;
  const inst_t INST_FCLASS_S  = 'h003800d3;
  const inst_t INST_FCVT_S_W  = 'h00068053;
  const inst_t INST_FCVT_S_WU = 'h000680d3;
  const inst_t INST_FMV_W_X   = 'h003c0053;
`endif  // RV32F

`ifdef RV64F
  const inst_t INST_FCVT_L_S  = 'h00060153;
  const inst_t INST_FCVT_LU_S = 'h000601d3;
  const inst_t INST_FCVT_S_L  = 'h00068153;
  const inst_t INST_FCVT_S_LU = 'h000681d3;
`endif  // RV64F

`ifdef RV32D
  const inst_t INST_FLD       = 'h00000187;
  const inst_t INST_FSD       = 'h000001a7;
  const inst_t INST_FMADD_D   = 'h000000c3;
  const inst_t INST_FMSUB_D   = 'h000000c7;
  const inst_t INST_FNMSUB_D  = 'h000000cb;
  const inst_t INST_FNMADD_D  = 'h000000cf;
  const inst_t INST_FADD_D    = 'h000000d3;
  const inst_t INST_FSUB_D    = 'h000002d3;
  const inst_t INST_FMUL_D    = 'h000004d3;
  const inst_t INST_FDIV_D    = 'h000006d3;
  const inst_t INST_FSQRT_D   = 'h0002d053;
  const inst_t INST_FSGNJ_D   = 'h00004453;
  const inst_t INST_FSGNJN_D  = 'h000044d3;
  const inst_t INST_FSGNJX_D  = 'h00004553;
  const inst_t INST_FMIN_D    = 'h00005453;
  const inst_t INST_FMAX_D    = 'h000054d3;
  const inst_t INST_FCVT_S_D  = 'h000200d3;
  const inst_t INST_FCVT_D_S  = 'h00021053;
  const inst_t INST_FEQ_D     = 'h00014553;
  const inst_t INST_FLT_D     = 'h000144d3;
  const inst_t INST_FLE_D     = 'h00014453;
  const inst_t INST_FCLASS_D  = 'h003880d3;
  const inst_t INST_FCVT_W_D  = 'h00061053;
  const inst_t INST_FCVT_WU_D = 'h000610d3;
  const inst_t INST_FCVT_D_W  = 'h00069053;
  const inst_t INST_FCVT_D_WU = 'h000690d3;
`endif  // RV32D

`ifdef RV64D
  const inst_t INST_FCVT_L_D  = 'h00061153;
  const inst_t INST_FCVT_LU_D = 'h000611d3;
  const inst_t INST_FMV_X_D   = 'h00388053;
  const inst_t INST_FCVT_D_L  = 'h00069153;
  const inst_t INST_FCVT_D_LU = 'h000691d3;
  const inst_t INST_FMV_D_X   = 'h003c8053;
`endif  // RV64D

`ifdef RV32Q
  const inst_t INST_FLQ       = 'h00000207;
  const inst_t INST_FSQ       = 'h00000227;
  const inst_t INST_FMADD_Q   = 'h000001c3;
  const inst_t INST_FMSUB_Q   = 'h000001c7;
  const inst_t INST_FNMSUB_Q  = 'h000001cb;
  const inst_t INST_FNMADD_Q  = 'h000001cf;
  const inst_t INST_FADD_Q    = 'h000001d3;
  const inst_t INST_FSUB_Q    = 'h000003d3;
  const inst_t INST_FMUL_Q    = 'h000005d3;
  const inst_t INST_FDIV_Q    = 'h000007d3;
  const inst_t INST_FSQRT_Q   = 'h0002f053;
  const inst_t INST_FSGNJ_Q   = 'h00004c53;
  const inst_t INST_FSGNJN_Q  = 'h00004cd3;
  const inst_t INST_FSGNJX_Q  = 'h00004d53;
  const inst_t INST_FMIN_Q    = 'h00005c53;
  const inst_t INST_FMAX_Q    = 'h00005cd3;
  const inst_t INST_FCVT_S_Q  = 'h000201d3;
  const inst_t INST_FCVT_Q_S  = 'h00023053;
  const inst_t INST_FCVT_D_Q  = 'h000211d3;
  const inst_t INST_FCVT_Q_D  = 'h000230d3;
  const inst_t INST_FEQ_Q     = 'h00014d53;
  const inst_t INST_FLT_Q     = 'h00014cd3;
  const inst_t INST_FLE_Q     = 'h00014c53;
  const inst_t INST_FCLASS_Q  = 'h003980d3;
  const inst_t INST_FCVT_W_Q  = 'h00063053;
  const inst_t INST_FCVT_WU_Q = 'h000630d3;
  const inst_t INST_FCVT_Q_W  = 'h0006b053;
  const inst_t INST_FCVT_Q_WU = 'h0006b0d3;
`endif  // RV32Q

`ifdef RV64Q
  const inst_t INST_FCVT_L_Q  = 'h00063153;
  const inst_t INST_FCVT_LU_Q = 'h000631d3;
  const inst_t INST_FCVT_Q_L  = 'h0006b153;
  const inst_t INST_FCVT_Q_LU = 'h0006b1d3;
`endif  // RV64Q

