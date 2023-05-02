`include "string_ops_pkg.sv"

module tb_strop;
    initial begin
        $dumpfile("raw.vcd");
        $dumpvars;
        $display("%c[7;38m################################# TEST STARTED #################################%c[0m", 27, 27);
    end
    final begin
        $display("%c[7;38m################################## TEST ENDED ##################################%c[0m", 27, 27);
    end

    initial begin
        $display("%0d", string_ops_pkg::string_get("A=2 B=5 C=4", "A"));
        $display("%0d", string_ops_pkg::string_get("A=2 B=5 C=4", "B"));
        $display("%0d", string_ops_pkg::string_get("A=2 B=5 C=4", "C"));
    end
endmodule