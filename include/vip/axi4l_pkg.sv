// ### Author : Foez Ahmed (foez.official@gmail.com))

package axi4l_pkg;

  `include "axi4l/typedef.svh"












  class axi4_seq_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  );

    rand bit [           0:0] _type;
    rand bit [ADDR_WIDTH-1:0] _addr;
    rand bit [           2:0] _prot;
    bit      [           7:0] _data [$:127];
    bit      [           0:0] _strb [$:127];

    function void post_randomize();
      _data.delete();
      _strb.delete();
      for (int i = (_addr % (DATA_WIDTH / 8)); i < DATA_WIDTH / 8; i++) begin
        _data.push_back($urandom);
        _strb.push_back($urandom);
      end
    endfunction

    // FUNCTION TO STRING TODO

    // FUNCTION GEN TX TODO

  endclass













  class axi4l_resp_item #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  ) extends axi4_seq_item #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

    bit    [ 1:0] _resp;
    bit    [63:0] _ax_clk;
    bit    [63:0] _x_clk;
    bit    [63:0] _resp_clk;
    string        _notes;

    // FUNCTION TO STRING TODO

  endclass













  class axi4_driver #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0,
      parameter bit ROLE       = 0
  );

    `AXI4L_T(axi, ADDR_WIDTH, DATA_WIDTH)

    mailbox #(axi4_seq_item_t) mbx;
    mailbox #(axi4_seq_item_t) wr_mbx = new(1);
    mailbox #(axi4_seq_item_t) rd_mbx = new(1);

    typedef axi4_seq_item#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) axi4_seq_item_t;

    virtual axi4l_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) intf;

    function new(
    virtual axi4l_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
    ) _intf);
      intf = _intf;
    endfunction

    task automatic reset();
      if (ROLE) begin
        intf.manager_reset();
      end else begin
        intf.subordinate_reset();
      end
    endtask

    task automatic stop();
      disable start;
      if (ROLE) begin
        intf.manager_reset();
      end else begin
        intf.subordinate_reset();
      end
    endtask

    task automatic start();
      reset();
      while (mbx == null) begin
        intf.clk_delay();
      end
      fork
        forever begin
          axi4_seq_item_t item;
          mbx.get(item);
          if (item._type) begin
            // generate write
          end else begin
            // generate read
          end
        end
      join_none
    endtask

  endclass













  class axi4_monitor #(
      parameter int ADDR_WIDTH = 0,
      parameter int DATA_WIDTH = 0
  );

    typedef axi4_resp_item#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) axi4_resp_item_t;

    `AXI4L_T(axi, ADDR_WIDTH, DATA_WIDTH)

    mailbox #(axi4_resp_item_t) mbx;

    virtual axi4l_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) intf;

    function new(
    virtual axi4l_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
    ) _intf);
      intf = _intf;
    endfunction

    task automatic reset();
      intf.monitor_reset();
    endtask

    task automatic stop();
      disable start;
      intf.monitor_reset();
    endtask

    task automatic start();
      reset();
      while (mbx == null) begin
        intf.clk_delay();
      end
    endtask

  endclass













endpackage
