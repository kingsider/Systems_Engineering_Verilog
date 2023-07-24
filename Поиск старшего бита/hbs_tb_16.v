`timescale 1ns/1ns

 module high_bit_search_tb;
   localparam TB_INPUT_WIDTH = 16;

    reg tb_clk = 1;
    reg [TB_INPUT_WIDTH-1:0] input_data;
    reg [TB_INPUT_WIDTH-1:0] idx; 
  

    initial 
        forever #5 tb_clk=~tb_clk;

    integer tb_data[9:0];

    initial 
    begin
    
    tb_data[0] = 16'h16DE;
    tb_data[1] = 16'h5403;
    tb_data[2] = 16'h00BE;
    tb_data[3] = 16'h0F15;
    tb_data[4] = 16'h87CA;
    tb_data[5] = 16'h0124;
    tb_data[6] = 16'h23BA;
    tb_data[7] = 16'hBF76;
    tb_data[8] = 16'h14DE;
    tb_data[9] = 16'h7643;
    input_data = 0; 
    for(idx = 0; idx < 10; idx = idx + 1)
    begin 
        input_data = tb_data[idx]; 
        #10; 
    end
    end

    initial
    begin
        $dumpfile("high_bit_search.vcd");
        $dumpvars(0, high_bit_search_tb);
    end

    high_bit_search #(.INPUT_WIDTH(TB_INPUT_WIDTH)) high_bit_search_instance (
    .clk(tb_clk),
    .input_data(input_data)
    );

endmodule 