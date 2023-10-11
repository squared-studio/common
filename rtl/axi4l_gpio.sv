// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

//`include "addr_map.svh"
//`include "axi4l_assign.svh"
//`include "axi4l_typedef.svh"
//`include "axi4_assign.svh"
//`include "axi4_typedef.svh"
`include "default_param_pkg.sv"

module axi4l_gpio #(
    parameter  type axi4l_req_t  = default_param_pkg::axi4l_req_t,
    parameter  type axi4l_resp_t = default_param_pkg::axi4l_resp_t,
    parameter  int  PORT_SIZE    = 5,
    localparam int  PortBytes    = (2 ** PORT_SIZE)
) (
    input  logic                             clk_i,
    input  logic                             arst_ni,
    input  axi4l_req_t                       req_i,
    output axi4l_resp_t                      resp_o,
    inout  wire         [PortBytes-1:0][7:0] port_io
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int AddrWidth = $bits(req_i.aw.addr);
  localparam int DataWidth = $bits(resp_o.r.data);
  localparam int DataBytes = DataWidth / 8;
  localparam int DataSize = $clog2(DataBytes);

  localparam int BlockSize = (DataSize > PORT_SIZE) ? DataSize : PORT_SIZE;
  localparam int MinBytes = (DataBytes > PortBytes) ? PortBytes : DataBytes;

  localparam int RdataBase = (2 ** BlockSize) / DataBytes * 0;
  localparam int WdataBase = (2 ** BlockSize) / DataBytes * 1;
  localparam int WenBase = (2 ** BlockSize) / DataBytes * 2;
  localparam int PullBase = (2 ** BlockSize) / DataBytes * 3;
  localparam int NumRows = (2 ** BlockSize) / DataBytes * 4;
  localparam int RowPerType = (2 ** BlockSize) / DataBytes * 1;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  axi4l_req_t                                      req;
  axi4l_resp_t                                     resp;

  wire         [  NumRows-1:0][DataBytes-1:0][7:0] mem;
  wire         [DataBytes-1:0][          7:0]      wr_data_row;
  wire         [DataBytes-1:0][          0:0]      wr_strb_row;

  wire         [  NumRows-1:0][DataBytes-1:0]      wen_demux;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign resp.b.resp = (req.aw.prot[1] != 0) ? 2 :
                    ( ((req.aw.addr[AddrWidth-1:DataSize]) < WdataBase) ? 2 : 0 );
  assign resp.r.resp = (req.ar.prot[1] != 0) ? 2 : 0;

  assign wr_strb_row = (resp.b.resp == 0) ? req.w.strb : '0;

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

  axi_fifo #(
      .axi_req_t    (axi4l_req_t),
      .axi_resp_t   (axi4l_resp_t),
      .AW_FIFO_DEPTH(4),
      .W_FIFO_DEPTH (4),
      .B_FIFO_DEPTH (4),
      .AR_FIFO_DEPTH(4),
      .R_FIFO_DEPTH (4)
  ) u_axi_fifo (
      .clk_i  (clk_i),
      .arst_ni(arst_ni),
      .req_i  (req_i),
      .resp_o (resp_o),
      .req_o  (req),
      .resp_i (resp)
  );

  demux #(
      .NUM_ELEM  (NumRows),
      .ELEM_WIDTH(DataBytes)
  ) u_demux (
      .s_i(),  // TODO : WR_ADDR
      .i_i(wr_strb_row),
      .o_o(wen_demux)
  );

  for (genvar i = 0; i < RowPerType; i++) begin : g_reg_row

    for (genvar j = 0; j < MinBytes; j++) begin : g_reg_wdata
      register #(
          .ELEM_WIDTH (8),
          .RESET_VALUE(0)
      ) u_register (
          .clk_i(clk_i),
          .arst_ni(arst_ni),
          .en_i(wen_demux[WdataBase+i][j]),
          .d_i(wr_data_row[j]),
          .q_o(mem[WdataBase+i][j])
      );
    end

    for (genvar j = 0; j < MinBytes; j++) begin : g_reg_wen
      register #(
          .ELEM_WIDTH (8),
          .RESET_VALUE(0)
      ) u_register (
          .clk_i(clk_i),
          .arst_ni(arst_ni),
          .en_i(wen_demux[WenBase+i][j]),
          .d_i(wr_data_row[j]),
          .q_o(mem[WenBase+i][j])
      );
    end

    for (genvar j = 0; j < MinBytes; j++) begin : g_reg_pull
      register #(
          .ELEM_WIDTH (8),
          .RESET_VALUE(0)
      ) u_register (
          .clk_i(clk_i),
          .arst_ni(arst_ni),
          .en_i(wen_demux[PullBase+i][j]),
          .d_i(wr_data_row[j]),
          .q_o(mem[PullBase+i][j])
      );
    end

  end

  for (genvar i = 0; i < RowPerType; i++) begin : g_io_pad
    for (genvar j = 0; j < MinBytes; j++) begin : g_byte
      for (genvar k = 0; k < 8; k++) begin : g_wire
        io_pad #() u_io_pad (
            .pull_i (mem[PullBase+i][j][k]),
            .wdata_i(mem[WdataBase+i][j][k]),
            .wen_i  (mem[WenBase+i][j][k]),
            .rdata_o(mem[RdataBase+i][j][k]),
            .pin_io (port_io[i*DataBytes+j][k])
        );
      end
    end
  end

  mux #(
      .ELEM_WIDTH(DataBytes),
      .NUM_ELEM  (NumRows)
  ) u_mux (
      .s_i(req.ar.addr[AddrWidth-1:DataSize]),
      .i_i(mem),
      .o_o(resp.r.data)
  );

  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIAL{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////



  //}}}

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS{{{
  //////////////////////////////////////////////////////////////////////////////////////////////////

`ifdef SIMULATION
  initial begin
    $display("PortBytes  : %0d", PortBytes);
    $display("RdataBase  : %0d", DataBytes * RdataBase);
    $display("WdataBase  : %0d", DataBytes * WdataBase);
    $display("WenBase    : %0d", DataBytes * WenBase);
    $display("PullBase   : %0d", DataBytes * PullBase);
    $display("NumRows    : %0d", DataBytes * NumRows);
    $display("RowPerType : %0d", DataBytes * RowPerType);
  end
`endif  // SIMULATION

  //}}}

endmodule
