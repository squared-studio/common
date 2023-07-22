// ### Author : Foez Ahmed (foez.official@gmail.com)

(* no_ungroup *) (* no_boundary_optimization *) (* dont_touch = "true" *)
module inverter #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] d_i,
    output logic [WIDTH-1:0] q_o
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign q_o = ~d_i;

endmodule
