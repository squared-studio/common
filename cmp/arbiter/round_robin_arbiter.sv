module round_robin_arbiter #(
    parameter  CLOG2_NUM_REQ = 2,
    localparam NUM_REQ = (2**CLOG2_NUM_REQ)
) (
    input  logic               clk_i,
    input  logic               arst_n,
    input  logic [NUM_REQ-1:0] req,
    output logic [NUM_REQ-1:0] gnt
    );
    
    logic [CLOG2_NUM_REQ-1:0] xbar_sel;
    
    logic [NUM_REQ-1:0][CLOG2_NUM_REQ-1:0] req_in_sel;
    logic [NUM_REQ-1:0][CLOG2_NUM_REQ-1:0] gnt_in_sel;

    logic [NUM_REQ-1:0] req_xbar;
    logic [NUM_REQ-1:0] gnt_xbar;

    logic [CLOG2_NUM_REQ-1:0] gnt_code;

    logic gnt_found;

    xbar #(
        .ELEM_WIDTH ( 1 ),
        .NUM_ELEM   ( NUM_REQ  )
    )
    xbar_req (
        .input_select ( req_in_sel ),
        .inputs   ( req      ),
        .outputs  ( req_xbar )
    );

    xbar #(
        .ELEM_WIDTH ( 1 ),
        .NUM_ELEM   ( NUM_REQ  )
    )
    xbar_gnt (
        .input_select ( gnt_in_sel ),
        .inputs   ( gnt_xbar ),
        .outputs  ( gnt      )
    );
  

    generate;
        for (genvar i = 0; i < NUM_REQ; i++) begin
            assign req_in_sel[i] = i + xbar_sel;
        end
    endgenerate
    
    generate;
        for (genvar i = 0; i < NUM_REQ; i++) begin
            assign gnt_in_sel[i] = i + (NUM_REQ - xbar_sel);
        end
    endgenerate
    
    fixed_priority_arbiter #(
        .NUM_REQ ( NUM_REQ )
    ) u_fixed_priority_arbiter (
        .req  ( req_xbar ),
        .gnt  ( gnt_xbar )
    );

    priority_encoder #(
      .NUM_INPUTS ( NUM_REQ )
    )
    gnt_encode (
      .in  ( gnt      ),
      .out ( gnt_code )
    );
  
    assign gnt_found = |gnt;

    always_ff @(posedge clk_i or negedge arst_n) begin
        if (~arst_n) begin
            xbar_sel <= '0;
        end
        else begin
            if (gnt_found) begin
                xbar_sel <= gnt_code + 1;
            end
        end
    end
    
endmodule