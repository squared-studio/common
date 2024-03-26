// Description
// ### Author : Foez Ahmed (foez.official@gmail.com)

interface uart_if #(
    //-PARAMETERS
    //-LOCALPARAMS
) (
    //-PORTS
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-LOCALPARAMS GENERATED
  //////////////////////////////////////////////////////////////////////////////////////////////////

  parameter int ODD = 1;
  parameter int EVEN = 2;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-TYPEDEFS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic tx;
  logic rx;

  logic tx_active;
  logic rx_active;

  bit tx_queue[$];
  bit [7:0] rx_queue[$];

  int baud = 115200;
  int data_width = 8;
  int parity = 2;
  int stop_width = 2;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-ASSIGNMENTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-RTLS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  `define IS(__SIGNAL__)                                                                           \
    function automatic bit is_``__SIGNAL__`` ();                                                   \
      return ``__SIGNAL__``;                                                                       \
    endfunction                                                                                    \


  `IS(tx_active)
  `IS(rx_active)

  `define GET_SET(__SIGNAL__)                                                                      \
    function automatic int get_``__SIGNAL__``();                                                   \
      return ``__SIGNAL__``;                                                                       \
    endfunction                                                                                    \
    function automatic bit set_``__SIGNAL__``(input int _``__SIGNAL__``);                          \
      if (tx_active || rx_active) begin                                                            \
        return 0;                                                                                  \
      end else begin                                                                               \
        ``__SIGNAL__`` = _``__SIGNAL__``;                                                          \
        return 1;                                                                                  \
      end                                                                                          \
    endfunction                                                                                    \


  `GET_SET(baud)
  `GET_SET(data_width)
  `GET_SET(parity)
  `GET_SET(stop_width)

  function automatic void send(input bit [7:0] data);
    int num_one;
    tx_queue.push_back(0);
    for (int i = 0; i < data_width; i++) tx_queue.push_back(data[i]);

    num_one = 0;
    for (int i = 0; i < data_width; i++) if (data[i]) num_one++;

    case (parity)
      default: begin
      end
      ODD: begin
        if (num_one % 2) tx_queue.push_back(0);
        else tx_queue.push_back(1);
      end
      EVEN: begin
        if (num_one % 2) tx_queue.push_back(1);
        else tx_queue.push_back(0);
      end
    endcase

    repeat (stop_width) tx_queue.push_back(1);
  endfunction

  function automatic bit [7:0] recv();
    if (rx_queue.size()) return rx_queue.pop_front();
    else return 0;
  endfunction

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-SEQUENTIALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  always #1ps begin
    if (tx_queue.size()) begin
      realtime bit_time;
      tx_active <= 1;
      bit_time = 1s / baud;
      while (tx_queue.size()) begin
        tx = tx_queue.pop_front();
        #(bit_time);
      end
      tx_active <= 0;
    end
  end

  always @(negedge rx) begin
    realtime bit_time;
    bit [7:0] buffer;
    int num_one;
    bit is_ok;
    rx_active <= 1;
    bit_time = 1s / baud;
    #(0.5 * bit_time);

    buffer = '0;
    for (int i = 0; i < data_width; i++) begin
      #(bit_time);
      buffer[i] = rx;
    end

    num_one = 0;
    foreach (buffer[i]) begin
      if (buffer[i]) num_one++;
    end

    is_ok = 0;
    case (parity)
      ODD: begin
        #(bit_time);
        if ((rx == 0) && (num_one % 2 == 1)) is_ok = 1;
        if ((rx == 1) && (num_one % 2 == 0)) is_ok = 1;
      end
      EVEN: begin
        #(bit_time);
        if ((rx == 1) && (num_one % 2 == 1)) is_ok = 1;
        if ((rx == 0) && (num_one % 2 == 0)) is_ok = 1;
      end
      default: begin
        is_ok = 1;
      end
    endcase

    #(bit_time);
    if (is_ok) rx_queue.push_back(buffer);

    rx_active <= 0;
  end

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //-INITIAL CHECKS
  //////////////////////////////////////////////////////////////////////////////////////////////////


endinterface
