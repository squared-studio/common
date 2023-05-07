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
[NUM_REQ] req →   fixed_priority_arbiter   → [NUM_REQ] gnt
              ¦                            ¦
               ----------------------------
*/

module fixed_priority_arbiter #(
    parameter NUM_REQ = 4
) (
    input  logic [NUM_REQ-1:0] req,
    output logic [NUM_REQ-1:0] gnt
);

  logic [NUM_REQ-1:1] gnt_found;

  generate
    assign gnt_found[1] = gnt[0];
    for (genvar i = 2; i < NUM_REQ; i++) begin
      assign gnt_found[i] = gnt_found[i-1] | gnt[i-1];
    end
  endgenerate

  generate
    assign gnt[0] = req[0];
    for (genvar i = 1; i < NUM_REQ; i++) begin
      assign gnt[i] = gnt_found[i] ? '0 : req[i];
    end
  endgenerate

endmodule
