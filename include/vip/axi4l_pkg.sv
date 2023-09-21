// ### Author : Foez Ahmed (foez.official@gmail.com))

package axi4l_pkg;

  `include "axi4l_typedef.svh"

  class axi4_seq_item #(  //{{{
      parameter int ADDR_WIDTH = 32,
      parameter int DATA_WIDTH = 64
  );

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-LOCALPARAMS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam int DataBytes = (DATA_WIDTH / 8);

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-SIGNALS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    rand bit [           0:0] _type;
    rand bit [ADDR_WIDTH-1:0] _addr;
    rand bit [           2:0] _prot;
    bit      [           7:0] _data [$:127];
    bit      [           0:0] _strb [$:127];

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-METHODS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    function void post_randomize();
      _data.delete();
      _strb.delete();
      for (int i = (_addr % DataBytes); i < DataBytes; i++) begin
        _data.push_back($urandom);
        _strb.push_back($urandom);
      end
    endfunction

    // FUNCTION TO STRING TODO

    // FUNCTION GEN TX TODO

    //}}}

  endclass  //}}}

  class axi4l_resp_item #(  //{{{
      parameter int ADDR_WIDTH = 32,
      parameter int DATA_WIDTH = 64
  ) extends axi4_seq_item #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-SIGNALS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    bit      [1:0] _resp;
    realtime       _ax_clk;
    realtime       _x_clk;
    realtime       _resp_clk;
    string         _notes;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-METHODS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // FUNCTION TO STRING TODO

    //}}}

  endclass  //}}}

  class axi4l_mem;  //{{{
    bit [7:0] mem[2][longint];
  endclass  //}}}

  class axi4_driver #(  //{{{
      parameter int ADDR_WIDTH = 32,
      parameter int DATA_WIDTH = 64,
      parameter bit ROLE       = 0
  );

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-LOCALPARAMS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam int DataBytes = (DATA_WIDTH / 8);
    localparam int DataSize = $clog2(DataBytes);

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-TYPEDEFS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    `AXI4L_T(axi, ADDR_WIDTH, DATA_WIDTH)

    typedef axi4_seq_item#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) axi4_seq_item_t;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-SIGNALS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    mailbox #(axi4_seq_item_t) mbx;
    mailbox #(axi4_seq_item_t) wr_mbx = new(1);
    mailbox #(axi4_seq_item_t) rd_mbx = new(1);

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-VARIABLES{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    int aw_delay_min = 0;
    int  w_delay_min = 0;
    int  b_delay_min = 0;
    int ar_delay_min = 0;
    int  r_delay_min = 0;

    int aw_delay_max = 0;
    int  w_delay_max = 0;
    int  b_delay_max = 0;
    int ar_delay_max = 0;
    int  r_delay_max = 0;

    int failure_odds = 0;

    axi_aw_chan_t  aw_queue[$];
    axi_w_chan_t    w_queue[$];
    axi_b_chan_t    b_queue[$];
    axi_ar_chan_t  ar_queue[$];
    axi_r_chan_t    r_queue[$];

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-INTERFACES{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    virtual axi4l_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) intf;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-CLASSES{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    axi4l_mem mem_obj;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-METHODS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    function new(  //{{{
        virtual axi4l_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
        ) intf);
      if (!ROLE) begin
        mem_obj = new();
      end
      this.intf = intf;
    endfunction  //}}}

    task automatic reset();  //{{{
      aw_queue.delete();
      w_queue.delete();
      b_queue.delete();
      ar_queue.delete();
      r_queue.delete();
      if (ROLE) begin
        intf.manager_reset();
      end else begin
        intf.subordinate_reset();
      end
    endtask  //}}}

    task automatic stop();  //{{{
      disable start;
      reset();
    endtask  //}}}

    task automatic start();  //{{{
      reset();
      while (mbx == null) begin
        intf.clk_delay();
      end
      if (ROLE) begin  // is manager{{{
        fork
          forever begin  // generate beats{{{
            axi4_seq_item_t item;
            mbx.get(item);
            if (item._type) begin  // generate write beats{{{

              axi_aw_chan_t aw_beat;
              axi_w_chan_t  w_beat;
              axi_b_chan_t  b_beat;

              aw_beat.addr = item.addr;
              aw_beat.prot = item.prot;
              aw_queue.push_back(aw_beat);

              for (int i = (aw_beat.addr % DataBytes); i < DataBytes; i++) begin
                w_beat.data[i] = item.data[i-(aw_beat.addr%DataBytes)];
                w_beat.strb[i] = item.strb[i-(aw_beat.addr%DataBytes)];
              end
              w_queue.push_back(w_beat);

              b_queue.push_back(b_beat);

            end //}}}
            else begin // generate read beats{{{

              axi_ar_chan_t ar_beat;
              axi_r_chan_t  r_beat;

              ar_beat.addr = item.addr;
              ar_beat.prot = item.prot;
              ar_queue.push_back(ar_beat);

              r_queue.push_back(r_beat);

            end  //}}}
          end  //}}}
          forever begin  // aw_channel drive{{{
            if (aw_queue.size()) begin
              repeat ($urandom_range(aw_delay_min, aw_delay_max)) intf.clk_delay();
              intf.send_aw(aw_queue.pop_front());
            end else begin
              intf.clk_delay();
            end
          end  //}}}
          forever begin  // w_channel drive{{{
            if (w_queue.size()) begin
              repeat ($urandom_range(w_delay_min, w_delay_max)) intf.clk_delay();
              intf.send_w(w_queue.pop_front());
            end else begin
              intf.clk_delay();
            end
          end  //}}}
          forever begin  // b_channel drive{{{
            if (b_queue.size()) begin
              axi_b_chan_t b_beat;
              repeat ($urandom_range(b_delay_min, b_delay_max)) intf.clk_delay();
              intf.recv_b(b_beat);
              b_queue.delete(0);
            end else begin
              intf.clk_delay();
            end
          end  //}}}
          forever begin  // ar_channel drive{{{
            if (ar_queue.size()) begin
              repeat ($urandom_range(ar_delay_min, ar_delay_max)) intf.clk_delay();
              intf.send_ar(ar_queue.pop_front());
            end else begin
              intf.clk_delay();
            end
          end  //}}}
          forever begin  // r_channel drive{{{
            if (r_queue.size()) begin
              axi_r_chan_t r_beat;
              repeat ($urandom_range(r_delay_min, r_delay_max)) intf.clk_delay();
              intf.recv_r(r_beat);
              r_queue.delete(0);
            end else begin
              intf.clk_delay();
            end
          end  //}}}
        join_none
      end  //}}}
      else begin  // is subordinate{{{
        fork
          forever begin  // aw_channel drive{{{
            axi_aw_chan_t aw_beat;
            repeat ($urandom_range(aw_delay_min, aw_delay_max)) intf.clk_delay();
            intf.recv_aw(aw_beat);
            aw_queue.push_back(aw_beat);
          end  //}}}
          forever begin  // w_channel drive{{{
            axi_w_chan_t w_beat;
            repeat ($urandom_range(w_delay_min, w_delay_max)) intf.clk_delay();
            intf.recv_w(w_beat);
            w_queue.push_back(w_beat);
          end  //}}}
          forever begin  // b_channel drive{{{
            if (b_queue.size()) begin
              repeat ($urandom_range(b_delay_min, b_delay_max)) intf.clk_delay();
              intf.send_b(b_queue.pop_front());
            end else begin
              intf.clk_delay();
            end
          end  //}}}
          forever begin  // ar_channel drive{{{
            axi_ar_chan_t ar_beat;
            repeat ($urandom_range(ar_delay_min, ar_delay_max)) intf.clk_delay();
            intf.recv_ar(ar_beat);
            ar_queue.push_back(ar_beat);
          end  //}}}
          forever begin  // r_channel drive{{{
            if (r_queue.size()) begin
              repeat ($urandom_range(r_delay_min, r_delay_max)) intf.clk_delay();
              intf.send_b(r_queue.pop_front());
            end else begin
              intf.clk_delay();
            end
          end  //}}}
          forever begin  // generate beats{{{
            if (aw_queue.size() && w_queue.size()) begin  // write{{{
              axi_aw_chan_t aw_beat;
              axi_w_chan_t  w_beat;
              axi_b_chan_t  b_beat;
              aw_beat = aw_queue.pop_front();
              w_beat  = w_queue.pop_front();
              if (failure_odds > 0) begin
                if ($urandom_range(0, 99) inside {[0 : (failure_odds - 1)]}) begin
                  b_beat.resp = 2;
                end
              end
              if (b_beat.resp == 0) begin
                bit [63:0] raw_aligned_addr;
                raw_aligned_addr = '0;
                raw_aligned_addr[63:DataSize] = aw_beat.addr[63:DataSize];
                foreach (w_beat.data[i]) begin
                  if (w_beat.strb[i]) begin
                    mem_obj.mem[aw_beat.prot[1]][raw_aligned_addr+i] = w_beat.data[i];
                  end
                end
              end
              intf.send_b(b_beat);
            end  //}}}
            if (ar_queue.size()) begin  // read{{{
              axi_ar_chan_t ar_beat;
              axi_r_chan_t  r_beat;
              ar_beat = ar_queue.pop_front();
              if (failure_odds > 0) begin
                if ($urandom_range(0, 99) inside {[0 : (failure_odds - 1)]}) begin
                  r_beat.resp = 2;
                end
              end
              if (r_beat.resp == 0) begin
                bit [63:0] raw_aligned_addr;
                raw_aligned_addr = '0;
                raw_aligned_addr[63:DataSize] = ar_beat.addr[63:DataSize];
                foreach (r_beat.data[i]) begin
                  r_beat.data[i] = mem_obj.mem[aw_beat.prot[1]][raw_aligned_addr+i];
                end
              end
              intf.send_r(r_beat);
            end  //}}}
          end  //}}}
        join_none
      end  //}}}
    endtask  //}}}

    //}}}

  endclass  //}}}

  class axi4_monitor #(  //{{{
      parameter int ADDR_WIDTH = 32,
      parameter int DATA_WIDTH = 64
  );

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-LOCALPARAMS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam int DataBytes = (DATA_WIDTH / 8);
    localparam int DataSize = $clog2(DataBytes);

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-TYPEDEFS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    `AXI4L_T(axi, ADDR_WIDTH, DATA_WIDTH)

    typedef axi4_resp_item#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) axi4_resp_item_t;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-SIGNALS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    mailbox #(axi4_resp_item_t) mbx;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-VARIABLES{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    axi_aw_chan_t  aw_queue[$];
    axi_w_chan_t    w_queue[$];
    axi_b_chan_t    b_queue[$];
    axi_ar_chan_t  ar_queue[$];
    axi_r_chan_t    r_queue[$];

    realtime aw_time[$];
    realtime  w_time[$];
    realtime  b_time[$];
    realtime ar_time[$];
    realtime  r_time[$];

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-INTERFACES{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    virtual axi4l_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) intf;

    //}}}

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //-METHODS{{{
    //////////////////////////////////////////////////////////////////////////////////////////////////

    function new(  //{{{
        virtual axi4l_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
        ) _intf);
      intf = _intf;
    endfunction  //}}}

    task automatic reset();  //{{{
      aw_queue.delete();
      w_queue.delete();
      b_queue.delete();
      ar_queue.delete();
      r_queue.delete();
      aw_time.delete();
      w_time.delete();
      b_time.delete();
      ar_time.delete();
      r_time.delete();
      intf.monitor_reset();
    endtask  //}}}

    task automatic stop();  //{{{
      disable start;
      reset();
    endtask  //}}}

    task automatic start();  //{{{
      reset();
      while (mbx == null) begin
        intf.clk_delay();
      end
      fork
        forever begin  // aw_channel record{{{
          axi_aw_chan_t aw_beat;
          intf.look_aw(aw_beat);
          aw_queue.push_back(aw_beat);
          aw_time.push_back($realtime);
        end  //}}}
        forever begin  // w_channel record{{{
          axi_w_chan_t w_beat;
          intf.look_w(w_beat);
          w_queue.push_back(w_beat);
          w_time.push_back($realtime);
        end  //}}}
        forever begin  // b_channel record{{{
          axi_b_chan_t b_beat;
          intf.look_b(b_beat);
          b_queue.push_back(b_beat);
          b_time.push_back($realtime);
        end  //}}}
        forever begin  // ar_channel record{{{
          axi_ar_chan_t ar_beat;
          intf.look_ar(ar_beat);
          ar_queue.push_back(ar_beat);
          ar_time.push_back($realtime);
        end  //}}}
        forever begin  // r_channel record{{{
          axi_r_chan_t r_beat;
          intf.look_r(r_beat);
          r_queue.push_back(r_beat);
          r_time.push_back($realtime);
        end  //}}}
        forever begin  // generate response beat{{{
          while (aw_time.size() && w_time.size() && b_time.size()) begin
            axi4_resp_item_t item;
            item = new();
            item._type = 1;
            item._addr = aw_queue[0].addr;
            item._prot = aw_queue[0].prot;
            for (int i = (aw_queue[0].addr % DataBytes); i < DataBytes; i++) begin
              item._data.push_back(w_beat.data[i]);
              item._strb.push_back(w_beat.strb[i]);
            end
            item._resp     = b_beat.resp;
            item._ax_clk   = aw_time[0];
            item._x_clk    = w_time[0];
            item._resp_clk = b_time[0];
            mbx.put(item);
            aw_queue.delete(0);
            w_queue.delete(0);
            b_queue.delete(0);
            aw_time.delete(0);
            w_time.delete(0);
            b_time.delete(0);
          end
          while (ar_time.size() && r_time.size()) begin
            axi4_resp_item_t item;
            item = new();
            item._type = 0;
            item._addr = ar_queue[0].addr;
            item._prot = ar_queue[0].prot;
            for (int i = (ar_queue[0].addr % DataBytes); i < DataBytes; i++) begin
              item._data.push_back(r_beat.data[i]);
            end
            item._resp     = r_beat.resp;
            item._ax_clk   = ar_time[0];
            item._x_clk    = r_time[0];
            item._resp_clk = r_time[0];
            mbx.put(item);
            ar_queue.delete(0);
            r_queue.delete(0);
            ar_time.delete(0);
            r_time.delete(0);
          end
          intf.clk_delay();
        end  //}}}
      join_none
    endtask  //}}}

    //}}}

  endclass  //}}}

endpackage
