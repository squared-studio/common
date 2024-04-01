/*
The `axi4l_gpio` module is a General-Purpose Input/Output (GPIO) module that allows individual pins
to be programmed as either an input or an output. Each pin operates off of 4 different registers:

1. `rdata`: A read-only register for reading the actual value on the pin.
2. `wdata`: A read-write register for output or pull of the pin.
3. `wen`: Used to strongly drive the pin with `wdata`.
4. `pull`: Used to weakly drive the pin with `wdata`.

The `port_io` is a byte array, meaning each port is byte addressable. The number of bytes in the
port is defined by the parameter `PORT_SIZE`, so the port will have `2^PORT_SIZE` bytes.

The base address of each type of register is defined as follows:

```verilog
BlockSize = ((AXI_DATA_WIDTH/8) > (2**PORT_SIZE)) ?
                (AXI_DATA_WIDTH/8) :
                (2**PORT_SIZE) ;

RdataBase = BlockSize * 0;
WdataBase = BlockSize * 1;
WenBase   = BlockSize * 2;
PullBase  = BlockSize * 3;
```
The module uses an AXI FIFO to handle the AXI4L requests and responses. It also uses a demultiplexer
(`demux`) to handle the write strobe rows (`wr_strb_row`). For each row in the `RowPerType`, it uses
a register to handle the `wdata`, `wen`, and `pull` values. Finally, it uses an IO pad for each wire
in the byte in the `RowPerType` and a multiplexer (`mux`) to handle the response data.
Author : Foez Ahmed (foez.official@gmail.com)
*/

`include "default_param_pkg.sv"

module axi4l_gpio #(
    // type of AXI4L request
    parameter  type axi4l_req_t  = default_param_pkg::axi4l_req_t,
    // type of AXI4L response
    parameter  type axi4l_resp_t = default_param_pkg::axi4l_resp_t,
    // size of the port in bytes
    parameter  int  PORT_SIZE    = 5,
    localparam int  PortBytes    = (2 ** PORT_SIZE)
) (
    input logic clk_i,   // input clock signal
    input logic arst_ni, // asynchronous active low reset signal

    input axi4l_req_t req_i,  // AXI4L request input

    output axi4l_resp_t resp_o,  // AXI4L response output

    inout wire [PortBytes-1:0][7:0] port_io  // inout port array
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED

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

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  axi4l_req_t                                      req;
  axi4l_resp_t                                     resp;

  wire         [  NumRows-1:0][DataBytes-1:0][7:0] mem;
  wire         [DataBytes-1:0][          7:0]      wr_data_row;
  wire         [DataBytes-1:0][          0:0]      wr_strb_row;

  wire         [  NumRows-1:0][DataBytes-1:0]      wen_demux;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  assign resp.b.resp = (req.aw.prot[1] != 0) ? 2 :
                    ( ((req.aw.addr[AddrWidth-1:DataSize]) < WdataBase) ? 2 : 0 );
  assign resp.r.resp = (req.ar.prot[1] != 0) ? 2 : 0;

  assign wr_strb_row = (resp.b.resp == 0) ? req.w.strb : '0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
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

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
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

endmodule
