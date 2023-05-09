////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    AUTHOR      : Foez Ahmed
//    EMAIL       : foez.official@gmail.com
//
//    MODULE      : ...
//    DESCRIPTION : ...
//
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
                ----------------------------
               ¦                            ¦
[NumReq] req_i →   fixed_priority_arbiter   → [NumReq] gnt_o
               ¦                            ¦
                ----------------------------
*/

module fixed_priority_arbiter #(
    parameter int NumReq = 4
) (
    input  logic [NumReq-1:0] req_i,
    output logic [NumReq-1:0] gnt_o
);

  logic [NumReq-1:1] gnt_found;

  assign gnt_found[1] = gnt_o[0];
  for (genvar i = 2; i < NumReq; i++) begin : g_gnt_found_MSB
    assign gnt_found[i] = gnt_found[i-1] | gnt_o[i-1];
  end

  assign gnt_o[0] = req_i[0];
  for (genvar i = 1; i < NumReq; i++) begin : g_gnt_MSB
    assign gnt_o[i] = gnt_found[i] ? '0 : req_i[i];
  end

endmodule
