////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : string_ops_pkg
//    DESCRIPTION : testbench for string operations package
//
////////////////////////////////////////////////////////////////////////////////////////////////////

`include "vip/string_ops_pkg.sv"

module string_ops_pkg_tb;

  `include "vip/tb_ess.sv"

  import string_ops_pkg::string_get;
  import string_ops_pkg::string_find;
  import string_ops_pkg::string_insert;

  int fail;

  task static string_get_test();
    fail = 0;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "AW") != 5) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "W") != 4) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "B") != 3) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "AR") != 2) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "R") != 1) fail++;
    if (string_get("AW=5 W=4 B=3 AR=2 R=1", "C") != 0) fail++;
    result_print(!fail, "string_ops_pkg::string_get");
  endtask

  task static string_find_test();
    fail = 0;
    //               0         1         2         3         4         5
    //               012345678901234567890123456789012345678901234567890
    if (string_find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "uk,k") != 10) fail++;
    if (string_find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "otb") != 25) fail++;
    if (string_find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "tbmkl") != 26) fail++;
    if (string_find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "vftyh") != 5) fail++;
    if (string_find("xsergvftyhuk,klkjm,kihjriotbmklqgipem;fujhnjyggdcds", "11111") != 0) fail++;
    result_print(!fail, "string_ops_pkg::string_find");
  endtask

  task static string_insert_test();
    fail = 0;
    if (string_insert("st", 0, "Te") != "Test") fail++;
    if (string_insert("Tt", 1, "es") != "Test") fail++;
    if (string_insert("Te", 2, "st") != "Test") fail++;
    if (string_insert("Te", 3, "st") != "Test") fail++;
    result_print(!fail, "string_ops_pkg::string_insert");
  endtask


  initial begin

    string_get_test();
    string_find_test();
    string_insert_test();

  end

  initial begin
    #1 $finish;
  end

endmodule
