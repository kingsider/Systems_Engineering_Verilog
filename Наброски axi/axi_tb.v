module testbench;
  // объявление тактового сигнала
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
    // задание начальных значений
    clk = 0;
    stream_input_0 = 0;
    stream_input_1 = 0;
    select = 0;

    // генерирование тактового сигнала
    always #5 clk = ~clk;
    
    // генерация пакетов данных
    // для первого потока
    repeat (10) 
    begin
      stream_input_0 = $random;
      #100; // такт генерации данных
    end
    // для второго потока
    repeat (10) 
    begin
      stream_input_1 = $random;
      #75; // такт генерации данных
    end
    
    #5;
    // установка выбора потоков для мультиплексора
    select <= 2'b01;
    
    #10;
    // остановка работы в соответствии с протоколом AXI-Stream
    // отсылаем FlushPulse
    stream_input_0 <= 0;
    repeat @(posedge clk) begin
      if (TValid) begin
        // исходный поток подтверждает, что прекратил передачу данных
        break;
      end
    end
    
    // запись сигналов в файл VCD
    $dumpfile("axi_stream_mux.vcd");
    $dumpvars(0, testbench);
    
    // завершение тестового сценария
    $finish;
  end

endmodule