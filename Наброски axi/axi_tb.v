module testbench;
  // ���������� ��������� �������
  reg clk = 0;
  
  reg [DATA_WIDTH-1:0] stream_input_0;
  reg [DATA_WIDTH-1:0] stream_input_1;
  reg [NUM_STREAMS-1:0] select;
  wire [DATA_WIDTH-1:0] stream_output;
  wire TReady, TValid;

  axi_stream_mux #(
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_STREAMS(NUM_STREAMS)
  ) mux (
    .select(select),
    .stream_input_0(stream_input_0),
    .stream_input_1(stream_input_1),
    .stream_output(stream_output),
    .TReady(TReady),
    .TValid(TValid)
  );

  initial begin
    // ������� ��������� ��������
    clk = 0;
    stream_input_0 = 0;
    stream_input_1 = 0;
    select = 0;

    // ������������� ��������� �������
    always #5 clk = ~clk;
    
    // ��������� ������� ������
    // ��� ������� ������
    repeat (10) 
    begin
      stream_input_0 = $random;
      #100; // ���� ��������� ������
    end
    // ��� ������� ������
    repeat (10) 
    begin
      stream_input_1 = $random;
      #75; // ���� ��������� ������
    end
    
    #5;
    // ��������� ������ ������� ��� ��������������
    select <= 2'b01;
    
    #10;
    // ��������� ������ � ������������ � ���������� AXI-Stream
    // �������� FlushPulse
    stream_input_0 <= 0;
    repeat @(posedge clk) begin
      if (TValid) begin
        // �������� ����� ������������, ��� ��������� �������� ������
        break;
      end
    end
    
    // ������ �������� � ���� VCD
    $dumpfile("axi_stream_mux.vcd");
    $dumpvars(0, testbench);
    
    // ���������� ��������� ��������
    $finish;
  end

endmodule