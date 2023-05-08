////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : string_ops_pkg
//    DESCRIPTION : testbench for string operations package
//
////////////////////////////////////////////////////////////////////////////////////////////////////

`include "string_ops_pkg.sv"

module string_ops_pkg_tb;

  `include "tb_essentials.sv"

  import string_ops_pkg::string_get;

  import string_ops_pkg::find;

  int fail;

  initial begin

    fail = 0;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "AW") != 5) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "W") != 4) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "B") != 3) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "AR") != 2) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "R") != 1) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "C") != 0) fail++;
    result_print(!fail, "string_ops_pkg::string_get");

    fail = 0;
    //        0         1         2         3         4         5
    //        012345678901234567890123456789012345678901234567890
    if (find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "uk,k") !== 10) fail++;
    if (find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "otb" !== 25)) fail++;
    if (find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "tbmklqg") !== 26) fail++;
    if (find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "vftyh") !== 5) fail++;
    if (find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "11111") !== 'x) fail++;
    result_print(!fail, "string_ops_pkg::find");

    fail = 0;
  end

  initial begin
    #1 $finish;
  end

endmodule
